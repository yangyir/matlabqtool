function error_entrust_amount = clear_holding( obj, pct, times, ...
    competitor_rank, round_interval)
% ÿ��ί��ʹ�価���ɽ�
% ������ֵĺ���[���շ���δ��ƽ�ֵ���Ŀ���ʲ�,ԭ��]
% error_entrust_amount = clear_holding( obj, pct, times, ...
%     competitor_rank, round_interval)
% �������:pct�ٷֱ�[0~100],timesƽ�ֵ���������,competitor_rank���ּ۸���,round_intervalÿ�ֽ�����ļ��
% �������:δ��ί�гɹ��������ʹ���
% ---------------------------
% ���Ʒ� 20161111



if ~exist('pct', 'var')
    pct = 10;   % �ٷֱȵ�ֵĬ��Ϊ10%
end
if ~exist('times' , 'var')
    times = 10; % ƽ�ֵĴ���Ĭ��Ϊ��10��ƽ��
end             % ���ּ�(1/2/3/4/5)
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
fprintf('һ��ƽ�ֳ�������:ƽ��%0.1f%%,��%d�ν���ƽ��\r\n', pct, times);


%{
0,Ҫȫ������
1,���ȴ�book���浱ǰ��position�ڻ�ȡ���еĲ�λ
2,ʹ�ò��������Ҫƽ�ֵ�����
3,��������һƽ�֣�Ĭ�ϣ�1% ��ƽ��
%}
%% 
my_book     = obj.book;
my_book.cancel_pendingOptEntrusts(obj.counter);
obj.query_book_pendingEntrusts();  % һ��ȫ���ٽ���ɨ��
my_book.eod_netof_positions;       % ���ж������
my_position = my_book.positions;   % ���book���滹��δ�ɽ��ĵ�,���Ȳ���


%% ���������ÿ��Ҫƽ�ֵ�����
pos_node      = my_position.node;
len_pos_node  = length(pos_node);
error_entrust_amount  = zeros(len_pos_node, 1);     % ί��ʧ�ܺ��޷�ί��(�۶�/����/�����ֵ�۸�Ϊ0)����Ȩ��Ŀ
error_entrust_code    = cell(len_pos_node, 1);      % ί�е��ʲ�����
prepare_closed_amount = nan(len_pos_node, times);   % ÿ��׼��ƽ�ֵ���Ȩ����
eve_entru_pct = pct/times;                          % ÿ��ƽ��ʱ��İٷֱ�
for node_t = 1:len_pos_node
    error_entrust_code{node_t} = pos_node(node_t).instrumentCode;
    for j = 1:times
        prepare_closed_amount(node_t,j) = round((100 - eve_entru_pct*(j-1))*pos_node(node_t).volume/100)...
            - round((100 - eve_entru_pct*j)*pos_node(node_t).volume/100);
    end
end
%{
����:�д�����Ȩ,�д���ÿ��ƽ�ֵ���Ŀ
47    47    47    47    46    47    47    47    47    47
 5     6     5     5     6     5     5     6     5     5
 3     2     3     3     2     3     3     3     2     3
12    12    13    12    12    12    12    13    12    12
 0     1     0     0     1     0     0     1     0     0
 5     4     5     5     4     5     5     5     4     5
10    10    10    10    10    11    10    10    10    10
 0     0     1     0     0     0     0     1     0     0
 1     1     1     1     1     1     1     1     1     1
ƽ�ֹ���:0,ȡ����3�۸����ί��,�����ǰ�Ķ���3��Ϊ0(�۶�/�����ֵ),����ӵ�ί��ʧ�ܺ��޷�ί�е�������
1,���Ƚ����е���������һ����ί��,���ί��ʧ��(������ζ�ί��ʧ��,����ӵ�ί��ʧ�ܺ��޷�ί�е�������)
2,��ѯ,ֱ���ɽ�,�ٽ��г���,�ٽ���ί��,һֱѭ��,�������ί�е��޷���ʵ����(ί����һʱ�̲����۶�),�����
%}

%% ���ƽ��
for tm = 1:times
    this_round_amount = prepare_closed_amount(:,tm);      % ��ǰһ������׼��ƽ�ֵ���Ŀ
    sub_entrust_iter  = 0;                                % ��ǰһ��ѭ���Ĵ���
    while true
        sub_entrust_iter   = sub_entrust_iter + 1;
        this_round_finised = all(this_round_amount < 1); % ����ﵽ����ȫ�ɽ�������
        if this_round_finised
            break;
        end
        this_round_entrust_map = containers.Map;
        empty_entrust    = Entrust;
        empty_entrust(1) = [];
        
        for node_t = 1:len_pos_node % ��Ȩ��Լ��ί�е�Map����[std::map(std::string,std::list<Entrust>)]
            if this_round_amount(node_t) > 0
                stockCode = pos_node(node_t).instrumentCode;
                this_round_entrust_map(stockCode) = empty_entrust;
            end
        end
        
        % ������Ȩ����ί���µ�
        for node_t = 1:len_pos_node
            stockCode             = pos_node(node_t).instrumentCode;
            this_opt_entru_amount = this_round_amount(node_t); % ��ǰ������Ȩ��Ҫί�е�����
            if this_opt_entru_amount == 0
                continue;
            end
            
            % ��ȡί������
            entru_10_times = floor(this_opt_entru_amount/10);  % ����ί��10�ŵ�����
            entru_10_last  = mod(this_opt_entru_amount, 10);   % ����ί�в���10�ŵ�����
            if entru_10_times                                  % �����������10�����ί��
                if entru_10_last
                    entrust_amounts = [ones(1, entru_10_times)*10, entru_10_last];
                else
                    entrust_amounts = ones(1, entru_10_times)*10;
                end
            else
                entrust_amounts = entru_10_last;
            end
            
            % ��ȡί�м۸�[���ί�м۸�Ϊ0������]
            offset = '2';
            pos_node(node_t).quote.fillQuote;
            pos_longShortFlag = pos_node(node_t).longShortFlag;
            if pos_longShortFlag > 0 % ���
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
            if abs(entrust_price) < 1e-6          % �����ǰ�۸�Ϊ0[�����ֵ���ߴ����۶����],����
                error_entrust_amount(node_t) = error_entrust_amount(node_t) + sum(entrust_amounts);
                this_round_amount(node_t)    = 0;
                this_round_entrust_map.remove(stockCode);
                continue;
            end
            
            obj.opt = pos_node(node_t).quote;      % ָ�������ֵ
            for et  = 1:length(entrust_amounts)
                volume = entrust_amounts(et);      % ����ί��
                one_entrust = obj.place_entrust_opt(direc, volume, offset, entrust_price);
                if one_entrust.entrustStatus == 0  % ί��ʧ��[���㵽����ί�е�����]
                    error_entrust_amount(node_t) = error_entrust_amount(node_t) + volume;
                    this_round_amount(node_t)    = this_round_amount(node_t) - volume;
                else                               % ί�гɹ�,����ǰ��ί��Entrust��ӵ�map��,����push_back
                    this_opt_entrust        = this_round_entrust_map(stockCode);
                    this_opt_entrust(end+1) = one_entrust;
                    this_round_entrust_map(stockCode) = this_opt_entrust;
                end
            end
            
        end % for i = 1:len_pos_node[������Ȩ����ί���µ�]
        
        this_round_finised = all(this_round_amount < 1); 
        if this_round_finised
            break;
        end
        
        %%
        %{
        �����е���Ȩ�ɽ����ν��в�ѯ�ϲ�
        ����:���Ƚ��в�ѯ,��ν��г���,�ٽ��в�ѯ
        %}
        pause(1)
        iter_wait = 0; % �ȴ��Ĵ���
        while true
            this_round_personal_dealing_flag = true;  % ��һ�ֵľֲ���ȫ�ɽ�flag
            obj.query_book_pendingEntrusts();         % һ�����в�ѯ
            
            % �ж�����ί�е��ĳɽ����
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
            
            % ����ɽ���,�����ÿ����Ȩ�ĳɽ���������ƥ��
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
            
            % ����ȴ��Ĵ�������4���Ͻ��г���
            if iter_wait >= 5
                my_book.cancel_pendingOptEntrusts(obj.counter);
            end
            
            %{
            ������ڳ��˵���Ч�������������Чί�н��м���,ֻҪĳ��Ȩ������Ч[�µ�~=�ɽ�+����]
            �����Ȩ���ٽ��п���
            %}
            if iter_wait >= 10
                for node_t = 1:len_pos_node
                    if this_round_amount(node_t) == 0
                        continue;
                    else
                        stockCode   = pos_node(node_t).instrumentCode;
                        this_opt_entrust = this_round_entrust_map(stockCode);
                        deal_amount = 0;
                        iter_wait_not_dealed = false;       % �ڵȴ�������δ�ɽ�
                        for te = 1:length(this_opt_entrust) % ���ĳ��Ȩί�д���[�µ�~=�ɽ�+����],���ٿ���
                            if this_opt_entrust(te).is_entrust_closed
                                deal_amount = deal_amount + this_opt_entrust(te).dealVolume;
                            else
                                iter_wait_not_dealed = true;
                            end
                        end
                        if iter_wait_not_dealed % ����ڵȴ�������δ�ɽ����ٽ��д���
                            this_round_amount(node_t) = 0;
                        else
                            this_round_amount(node_t) = this_round_amount(node_t) - deal_amount;
                        end
                    end
                end
                break;
            end
            
            iter_wait = iter_wait + 1;
            fprintf('��%d�ֽ���,���ڵ�%d��ѭ���еĵ�%d�εȴ�......\r\n', tm, sub_entrust_iter, iter_wait);
            pause(1)
        end % while true[�����е���Ȩ�ɽ����ν��в�ѯ�ϲ�]
        
    end % while true
    fprintf('��%d�ֽ������,���Եȼ�����һ��ί��......\r\n', tm);
    pause(round_interval);
end % tm = 1:times

%% ������Ҫ����ĵ�[�۶�,����,�����ֵ�۸�Ϊ0����]
error_entrust_amount = [ {'����' , 'δ�µ�����'} ; error_entrust_code , ...
    num2cell(error_entrust_amount) ];










end % function eof

