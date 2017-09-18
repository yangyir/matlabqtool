function [ data, headers ] = toTable( obj, headers )
%TOTABLE �������ʱ�����У�����TEBase.data, TEBase.headers��
% ԭTradeList��EntrustList�е�������ͷ���ͳһ�����
% �ɹ����excel�á�Ticks,Bars,TradeList��Ҳ��ͬ���ĺ���
% headers�����ȼ�������� > obj.headers > default_headers(��Ҫ�򶼺���
% ===============================================================
% �̸գ�140805

%% Ԥ����

% ������ȫ����
all_fields = properties( obj );

% ѡ������N*1������ ���б�����
default_headers  = {};  % ����N*1������
default_headers2 = {}; % ���б�������ʱ����
lenN             = size(obj.time, 1);
for i = 1:length(all_fields)
    f   = all_fields{i};
    s1  = size( obj.(f), 1);
    s2  = size( obj.(f), 2);
    
    % ����N*1������
    if s1 == lenN && s2 == 1
        default_headers{end+1} = f;
    end
    
    % ���б�����
    if s1 == 1 && s2 == 1
        default_headers2{end+1} = f;
    end
end


    
    
if ~exist('headers', 'var')
    if isempty(obj.headers)
        headers = default_headers;
    else
        headers = obj.headers;
    end    
end


%% ʱ������������ ����data
data    = nan(lenN, length(headers));

for i = 1:length(headers)
    f = headers{i};
    try
        data(:,i) = obj.(f);
    catch e
        disp( [f '����'] );
    end
end

obj.data    = data;
obj.headers = headers;

%% ��Ϣ����, ����data2�����ޣ�




end


