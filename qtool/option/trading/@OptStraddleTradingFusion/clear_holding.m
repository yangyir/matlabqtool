function error_entrust_amount = clear_holding( obj, pct, times, ...
    competitor_rank, round_interval)
% 每轮委托使其尽量成交
% 进行清仓的函数[最终返回未能平仓的数目和资产,原因]
% error_entrust_amount = clear_holding( obj, pct, times, ...
%     competitor_rank, round_interval)
% 输入参数:pct百分比[0~100],times平仓的轮流次数,competitor_rank对手价格档数,round_interval每轮交易完的间隔
% 输出参数:未能委托成功的数量和代码
% ---------------------------
% 吴云峰 20161111



if ~exist('pct', 'var')
    pct = 10;   % 百分比的值默认为10%
end
if ~exist('times' , 'var')
    times = 10; % 平仓的次数默认为分10次平仓
end             % 对手价(1/2/3/4/5)
if ~exist('competitor_rank' , 'var')
    competitor_rank = 1;
end
if ~exist('round_interval' , 'var')
    round_interval = 6;
end
assert(times >= 1);
assert(round_interval > 0);
assert(pct >= 0 && pct <= 100);
assert(ismember(competitor_rank, 1:5));
times = round(times);
fprintf('一键平仓程序启动:平仓%0.1f%%,分%d次进行平仓\r\n', pct, times);


%{
0,要全部撤单
1,首先从book里面当前的position内获取所有的仓位
2,使用差量法算出要平仓的数量
3,最后进行逐一平仓（默认，1% 地平）
%}
%% 
my_book     = obj.book;
my_book.cancel_pendingOptEntrusts(obj.counter);
obj.query_book_pendingEntrusts();  % 一键全撤再进行扫描
my_book.eod_netof_positions;       % 进行多空轧差
my_position = my_book.positions;   % 如果book里面还有未成交的单,则先不管


%% 差量法算出每次要平仓的数量
pos_node      = my_position.node;
len_pos_node  = length(pos_node);
error_entrust_amount  = zeros(len_pos_node, 1);     % 委托失败和无法委托(熔断/对手/深度虚值价格为0)的期权数目
error_entrust_code    = cell(len_pos_node, 1);      % 委托的资产代码
prepare_closed_amount = nan(len_pos_node, times);   % 每次准备平仓的期权张数
eve_entru_pct = pct/times;                          % 每次平仓时候的百分比
for node_t = 1:len_pos_node
    error_entrust_code{node_t} = pos_node(node_t).instrumentCode;
    for j = 1:times
        prepare_closed_amount(node_t,j) = round((100 - eve_entru_pct*(j-1))*pos_node(node_t).volume/100)...
            - round((100 - eve_entru_pct*j)*pos_node(node_t).volume/100);
    end
end
%{
举例:行代表期权,列代表每次平仓的数目
47    47    47    47    46    47    47    47    47    47
 5     6     5     5     6     5     5     6     5     5
 3     2     3     3     2     3     3     3     2     3
12    12    13    12    12    12    12    13    12    12
 0     1     0     0     1     0     0     1     0     0
 5     4     5     5     4     5     5     5     4     5
10    10    10    10    10    11    10    10    10    10
 0     0     1     0     0     0     0     1     0     0
 1     1     1     1     1     1     1     1     1     1
平仓规则:0,取对手3价格进行委托,如果当前的对手3价为0(熔断/深度虚值),则添加到委托失败和无法委托的数量内
1,首先将所有的数量进行一次性委托,如果委托失败(如果三次都委托失败,则添加到委托失败和无法委托的数量内)
2,查询,直到成交,再进行撤单,再进行委托,一直循环,如果出现委托单无法真实撤销(委托下一时刻产生熔断),则放弃
%}

%% 逐次平仓
for tm = 1:times
    this_round_amount = prepare_closed_amount(:,tm);      % 当前一轮所有准备平仓的数目
    sub_entrust_iter  = 0;                                % 当前一轮循环的次数
    while true
        sub_entrust_iter   = sub_entrust_iter + 1;
        this_round_finised = all(this_round_amount < 1); % 如果达到了完全成交的条件
        if this_round_finised
            break;
        end
        this_round_entrust_map = containers.Map;
        empty_entrust    = Entrust;
        empty_entrust(1) = [];
        
        for node_t = 1:len_pos_node % 期权合约的委托单Map容器[std::map(std::string,std::list<Entrust>)]
            if this_round_amount(node_t) > 0
                stockCode = pos_node(node_t).instrumentCode;
                this_round_entrust_map(stockCode) = empty_entrust;
            end
        end
        
        % 所有期权进行委托下单
        for node_t = 1:len_pos_node
            stockCode             = pos_node(node_t).instrumentCode;
            this_opt_entru_amount = this_round_amount(node_t); % 当前这张期权需要委托的数量
            if this_opt_entru_amount == 0
                continue;
            end
            
            % 获取委托数量
            entru_10_times = floor(this_opt_entru_amount/10);  % 单笔委托10张的数量
            entru_10_last  = mod(this_opt_entru_amount, 10);   % 单笔委托不足10张的数量
            if entru_10_times                                  % 如果数量大于10则分批委托
                if entru_10_last
                    entrust_amounts = [ones(1, entru_10_times)*10, entru_10_last];
                else
                    entrust_amounts = ones(1, entru_10_times)*10;
                end
            else
                entrust_amounts = entru_10_last;
            end
            
            % 获取委托价格[如果委托价格为0则跳过]
            offset = '2';
            pos_node(node_t).quote.fillQuote;
            pos_longShortFlag = pos_node(node_t).longShortFlag;
            if pos_longShortFlag > 0 % 多仓
                direc = '2';
            else
                direc = '1';
            end
            switch competitor_rank
                case 1
                    if direc == '1'
                        entrust_price = pos_node(node_t).quote.askP1;
                    else
                        entrust_price = pos_node(node_t).quote.bidP1;
                    end
                case 2
                    if direc == '1'
                        entrust_price = pos_node(node_t).quote.askP2;
                    else
                        entrust_price = pos_node(node_t).quote.bidP2;
                    end
                case 3
                    if direc == '1'
                        entrust_price = pos_node(node_t).quote.askP3;
                    else
                        entrust_price = pos_node(node_t).quote.bidP3;
                    end
                case 4
                    if direc == '1'
                        entrust_price = pos_node(node_t).quote.askP4;
                    else
                        entrust_price = pos_node(node_t).quote.bidP4;
                    end
                case 5
                    if direc == '1'
                        entrust_price = pos_node(node_t).quote.askP5;
                    else
                        entrust_price = pos_node(node_t).quote.bidP5;
                    end
            end
            if abs(entrust_price) < 1e-6          % 如果当前价格为0[深度虚值或者处于熔断情况],跳过
                error_entrust_amount(node_t) = error_entrust_amount(node_t) + sum(entrust_amounts);
                this_round_amount(node_t)    = 0;
                this_round_entrust_map.remove(stockCode);
                continue;
            end
            
            obj.opt = pos_node(node_t).quote;      % 指针变量赋值
            for et  = 1:length(entrust_amounts)
                volume = entrust_amounts(et);      % 进行委托
                one_entrust = obj.place_entrust_opt(direc, volume, offset, entrust_price);
                if one_entrust.entrustStatus == 0  % 委托失败[划算到错误委托的情形]
                    error_entrust_amount(node_t) = error_entrust_amount(node_t) + volume;
                    this_round_amount(node_t)    = this_round_amount(node_t) - volume;
                else                               % 委托成功,将当前的委托Entrust添加到map内,进行push_back
                    this_opt_entrust        = this_round_entrust_map(stockCode);
                    this_opt_entrust(end+1) = one_entrust;
                    this_round_entrust_map(stockCode) = this_opt_entrust;
                end
            end
            
        end % for i = 1:len_pos_node[所有期权进行委托下单]
        
        this_round_finised = all(this_round_amount < 1); 
        if this_round_finised
            break;
        end
        
        %%
        %{
        将所有的期权成交情形进行查询合并
        步骤:首先进行查询,其次进行撤单,再进行查询
        %}
        pause(1)
        iter_wait = 0; % 等待的次数
        while true
            this_round_personal_dealing_flag = true;  % 这一轮的局部完全成交flag
            obj.query_book_pendingEntrusts();         % 一键进行查询
            
            % 判断所有委托单的成交情况
            this_round_total_entrust_list = values(this_round_entrust_map);
            for list_t = 1:length(this_round_total_entrust_list)
                one_opt_entrust_list = this_round_total_entrust_list{list_t};
                for one_t = 1:length(one_opt_entrust_list)
                    if one_opt_entrust_list(one_t).is_entrust_closed
                    else
                        this_round_personal_dealing_flag = false;
                    end
                end
            end
            
            % 如果成交了,则计算每张期权的成交数量进行匹配
            if this_round_personal_dealing_flag
                for node_t = 1:len_pos_node
                    if this_round_amount(node_t) == 0
                        continue;
                    else
                        stockCode   = pos_node(node_t).instrumentCode;
                        this_opt_entrust = this_round_entrust_map(stockCode);
                        deal_amount = 0;
                        for te = 1:length(this_opt_entrust)
                            deal_amount = deal_amount + this_opt_entrust(te).dealVolume;
                        end
                        this_round_amount(node_t) = this_round_amount(node_t) - deal_amount;
                    end
                end
                break;
            end
            
            % 如果等待的次数到了4以上进行撤单
            if iter_wait >= 5
                my_book.cancel_pendingOptEntrusts(obj.counter);
            end
            
            %{
            如果存在撤了单无效的情形则针对有效委托进行计算,只要某期权存在无效[下单~=成交+撤单]
            则该期权则不再进行考虑
            %}
            if iter_wait >= 10
                for node_t = 1:len_pos_node
                    if this_round_amount(node_t) == 0
                        continue;
                    else
                        stockCode   = pos_node(node_t).instrumentCode;
                        this_opt_entrust = this_round_entrust_map(stockCode);
                        deal_amount = 0;
                        iter_wait_not_dealed = false;       % 在等待中依旧未成交
                        for te = 1:length(this_opt_entrust) % 如果某期权委托存在[下单~=成交+撤单],则不再考虑
                            if this_opt_entrust(te).is_entrust_closed
                                deal_amount = deal_amount + this_opt_entrust(te).dealVolume;
                            else
                                iter_wait_not_dealed = true;
                            end
                        end
                        if iter_wait_not_dealed % 如果在等待中依旧未成交则不再进行处理
                            this_round_amount(node_t) = 0;
                        else
                            this_round_amount(node_t) = this_round_amount(node_t) - deal_amount;
                        end
                    end
                end
                break;
            end
            
            iter_wait = iter_wait + 1;
            fprintf('第%d轮交易,处于第%d次循环中的第%d次等待......\r\n', tm, sub_entrust_iter, iter_wait);
            pause(1)
        end % while true[将所有的期权成交情形进行查询合并]
        
    end % while true
    fprintf('第%d轮交易完毕,请稍等继续下一轮委托......\r\n', tm);
    pause(round_interval);
end % tm = 1:times

%% 意外需要处理的单[熔断,对手,深度虚值价格为0情形]
error_entrust_amount = [ {'代码' , '未下单数量'} ; error_entrust_code , ...
    num2cell(error_entrust_amount) ];










end % function eof

