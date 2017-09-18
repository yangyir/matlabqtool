function error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank)
% ���ݲ�λʣ������ʽ����ί��ƽ��
% һ����ֺ���
% error_entrust_amount = clear_holding_by_position(obj, pct, times, competitor_rank, beErrContinueEntrust)
% �������:pct�ٷֱ�[0~100],timesƽ�ֵ���������,competitor_rank���ּ۸���
% �������:δ��ί�гɹ��������ʹ���
% ---------------------------
% ���Ʒ� 20161115


if ~exist('pct', 'var')
    pct = 10;   % �ٷֱȵ�ֵĬ��Ϊ10%
end
if ~exist('times' , 'var')
    times = 10; % ƽ�ֵĴ���Ĭ��Ϊ��10��ƽ��
end             % ���ּ�(1/2/3/4/5)
if ~exist('competitor_rank' , 'var')
    competitor_rank = 1;
end
assert(pct >= 0 && pct <= 100);
assert(times >= 1);
assert(ismember(competitor_rank, 1:5));
times = round(times);
fprintf('һ��ƽ�ֳ�������[����ʣ���λƽ��]:ƽ��%0.1f%%,��%d�ν���ƽ��\r\n', pct, times);

%{
0,Ҫȫ������
1,���ȴ�book���浱ǰ��position�ڻ�ȡ���еĲ�λ
2,ʹ�ò��������ʣ���������ݶ�
3,��������һƽ�֣�Ĭ�ϣ�1% ��ƽ��
%}

%% ׼������,����
my_book     = obj.book;
my_book.cancel_pendingOptEntrusts(obj.counter);
obj.query_book_pendingEntrusts();
my_book.eod_netof_positions;
my_position = my_book.positions;


%% ʹ�ò��������ʣ���������ݶ�
pos_node      = my_position.node;
len_pos_node  = length(pos_node);
error_entrust_code   = cell(len_pos_node, 1);     % ί�е��ʲ�����
error_entrust_flag   = false(len_pos_node, 1);    % �޷�ί�е���Ȩ
remain_pos_amount    = nan(len_pos_node, times);  % ÿ��ƽ�ֵ�ʣ������
eve_entru_pct = pct/times;                        % ÿ��ƽ��ʱ��İٷֱ�
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
ƽ�ֹ���:
0,ȡ���ּ۸����ί��,һ����ǰ�Ķ��ּ�Ϊ0(�۶�/�����ֵ),��ǰ���ʲ����ٽ�ί��
1,���е�ǰĿ��ʣ������ί��
2,��ѯ3��,ֱ���ɽ�,�ٽ��г���,�ٽ��еȴ�,ֱ���������
%}


%% ���ƽ��

for tm = 1:times
    this_round_remain_amount = remain_pos_amount(:,tm); % ������Ҫ��ʣ������
    opt_curr_volume          = nan(len_pos_node, 1);    % ������Ȩ�ĵ�ǰ����
    for node_t = 1:len_pos_node
        opt_curr_volume(node_t) = pos_node(node_t).volume;
    end
    % ������Ҫί�е�����
    this_round_entru_amount  = opt_curr_volume - this_round_remain_amount;
    while true
        % ί���µ�����
        for node_t = 1:len_pos_node
            if error_entrust_flag(node_t) % �����ǰ�ʲ�֮ǰί�г����������ٽ��п���
                continue;
            end
            this_opt_entru_amount = this_round_entru_amount(node_t);
            if this_opt_entru_amount < 1
                continue;
            end
            stockCode    = pos_node(node_t).instrumentCode;  % �ʲ�����
            aim_Remain_Q = this_round_remain_amount(node_t); % Ŀ���λ
            
            % ί���µ�
            success = my_book.clear_opt_entrust_once(stockCode, aim_Remain_Q, obj.counter, competitor_rank);
            if success
            else
                error_entrust_flag(node_t) = true;
            end
        end
        
        % ���в�ѯ�ͳ���
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
    fprintf('��%d����ֽ���...\r\n', tm);
end % tm = 1:times


%% ������δί�гɹ��Ĳ�λ
for node_t = 1:len_pos_node
    opt_curr_volume(node_t) = pos_node(node_t).volume;
end
error_entrust_amount = opt_curr_volume - remain_pos_amount(:,end);
error_entrust_amount = [ {'����' , 'δ�µ�����'} ; error_entrust_code , ...
    num2cell(error_entrust_amount) ];











end