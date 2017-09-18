function error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank)
% 依据仓位剩余量方式进行委托平仓
% 一键清仓函数
% error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank, beErrContinueEntrust)
% 输入参数:pct百分比[0~100],times平仓的轮流次数,competitor_rank对手价格档数
% 输出参数:未能委托成功的数量和代码
% ---------------------------
% 吴云峰 20161115


if ~exist('pct', 'var')
    pct = 10;   % 百分比的值默认为10%
end
if ~exist('times' , 'var')
    times = 10; % 平仓的次数默认为分10次平仓
end             % 对手价(1/2/3/4/5)
if ~exist('competitor_rank' , 'var')
    competitor_rank = 1;
end
assert(pct >= 0 && pct <= 100);
assert(times >= 1);
assert(ismember(competitor_rank, 1:5));
times = round(times);
fprintf('一键平仓程序启动[基于剩余仓位平仓]:平仓%0.1f%%,分%d次进行平仓\r\n', pct, times);

%{
0,要全部撤单
1,首先从book里面当前的position内获取所有的仓位
2,使用差量法算出剩余数量的梯度
3,最后进行逐一平仓（默认，1% 地平）
%}

%% 准备工作,撤单
my_book     = obj.book;
my_book.cancel_pendingOptEntrusts(obj.counter);
obj.query_book_pendingEntrusts();
my_book.eod_netof_positions;
my_position = my_book.positions;


%% 使用差量法算出剩余数量的梯度
pos_node      = my_position.node;
len_pos_node  = length(pos_node);
error_entrust_code   = cell(len_pos_node, 1);     % 委托的资产代码
error_entrust_flag   = false(len_pos_node, 1);    % 无法委托的期权
remain_pos_amount    = nan(len_pos_node, times);  % 每次平仓的剩余数量
eve_entru_pct = pct/times;                        % 每次平仓时候的百分比
for node_t = 1:len_pos_node
    total_amount = pos_node(node_t).volume;
    error_entrust_code{node_t} = pos_node(node_t).instrumentCode;
    for times_t = 1:times
        remain_pos_amount(node_t, times_t) = total_amount - round(eve_entru_pct*times_t/100*total_amount);
    end
end
%{
922         907         891         875         860         844
935         919         903         888         872         856
1197        1176        1156        1136        1116        1095
53          52          51          50          49          49
240         236         232         228         224         220
7           7           7           7           6           6
92          91          89          88          86          85
199         195         192         189         185         182
4           4           4           4           4           4
21          20          20          20          19          19
平仓规则:
0,取对手价格进行委托,一旦当前的对手价为0(熔断/深度虚值),则当前的资产不再进委托
1,进行当前目标剩余量的委托
2,查询3次,直到成交,再进行撤单,再进行等待,直到撤单完毕
%}


%% 逐次平仓

for tm = 1:times
    this_round_remain_amount = remain_pos_amount(:,tm); % 本轮需要的剩余数量
    opt_curr_volume          = nan(len_pos_node, 1);    % 所有期权的当前数量
    for node_t = 1:len_pos_node
        opt_curr_volume(node_t) = pos_node(node_t).volume;
    end
    % 本轮需要委托的数量
    this_round_entru_amount  = opt_curr_volume - this_round_remain_amount;
    while true
        % 委托下单操作
        for node_t = 1:len_pos_node
            if error_entrust_flag(node_t) % 如果当前资产之前委托出现问题则不再进行考虑
                continue;
            end
            this_opt_entru_amount = this_round_entru_amount(node_t);
            if this_opt_entru_amount < 1
                continue;
            end
            stockCode    = pos_node(node_t).instrumentCode;  % 资产代码
            aim_Remain_Q = this_round_remain_amount(node_t); % 目标仓位
            
            % 委托下单
            success = my_book.clear_opt_entrust_once(stockCode, aim_Remain_Q, obj.counter, competitor_rank);
            if success
            else
                error_entrust_flag(node_t) = true;
            end
        end
        
        % 进行查询和撤单
        pause(1)
        iter_wait = 0;
        while iter_wait < 6
            obj.query_book_pendingEntrusts();
            if iter_wait > 4
                my_book.cancel_pendingOptEntrusts(obj.counter);
            end
            iter_wait = iter_wait + 1;
            pause(1);
        end
        obj.query_book_pendingEntrusts();
        break;
    end % while true
    fprintf('第%d轮清仓结束...\r\n', tm);
end % tm = 1:times


%% 处理尚未委托成功的仓位
for node_t = 1:len_pos_node
    opt_curr_volume(node_t) = pos_node(node_t).volume;
end
error_entrust_amount = opt_curr_volume - remain_pos_amount(:,end);
error_entrust_amount = [ {'代码' , '未下单数量'} ; error_entrust_code , ...
    num2cell(error_entrust_amount) ];











end