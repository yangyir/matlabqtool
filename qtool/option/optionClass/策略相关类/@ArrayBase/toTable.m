function [ table, flds ] = toTable( obj, start_pos, end_pos)
%TOTABLE ÿ��nodeдһ�У�����д


% �������ʱ�����У�����TEBase.data, TEBase.headers��
% ԭTradeList��EntrustList�е�������ͷ���ͳһ�����
% �ɹ����excel�á�Ticks,Bars,TradeList��Ҳ��ͬ���ĺ���
% headers�����ȼ�������� > obj.headers > default_headers(��Ҫ�򶼺���
% ===============================================================
% �̸գ�140805


%% �򵥰汾������ֵ���Ǳ���

if ~exist('start_pos', 'var')
    start_pos = 1;
end

if ~exist('end_pos', 'var')
    end_pos = start_pos + length(obj.node) - 1; 
end

nodes = obj.node(start_pos : end_pos);
N = length(nodes);

flds = properties( nodes );
F = length(flds);

table = cell(N+1, F);


% ��һ��д����
for col = 1:F
    f = flds{col};
    table{1, col} = f;
end


% ��2��N+1��д���ݣ��������ݶ��Ǳ���
for lin = 1:N
    for col = 1:F
        n = nodes(lin);
        f = flds{col};
        table{lin+1, col} = n.(f);
    end
end


%%

obj.table   = table;
obj.headers = flds;

end



 %% Ԥ����
% 
% % ������ȫ����
% all_fields = properties( obj );
% 
% % ѡ������N*1������ ���б�����
% default_headers  = {};  % ����N*1������
% default_headers2 = {}; % ���б�������ʱ����
% lenN             = size(obj.time, 1);
% for i = 1:length(all_fields)
%     f   = all_fields{i};
%     s1  = size( obj.(f), 1);
%     s2  = size( obj.(f), 2);
%     
%     % ����N*1������
%     if s1 == lenN && s2 == 1
%         default_headers{end+1} = f;
%     end
%     
%     % ���б�����
%     if s1 == 1 && s2 == 1
%         default_headers2{end+1} = f;
%     end
% end
% 
% 
%     
%     
% if ~exist('headers', 'var')
%     if isempty(obj.headers)
%         headers = default_headers;
%     else
%         headers = obj.headers;
%     end    
% end
% 
% 
% %% ʱ������������ ����data
% data    = nan(lenN, length(headers));
% 
% for i = 1:length(headers)
%     f = headers{i};
%     try
%         data(:,i) = obj.(f);
%     catch e
%         disp( [f '����'] );
%     end
% end




%% ��Ϣ����, ����data2�����ޣ�






