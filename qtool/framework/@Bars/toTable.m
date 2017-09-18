function [ data, headers, data2] = toTable( obj, headers )
% ��bars�е����ݷŽ�һ��matrix�����obj.data, obj.header
% TicksҲ�д˺���
% headers�����ȼ������ > obj.headers > default_headers(��Ҫ�򶼺���
% ===============================================================
% �̸գ�20131211
% �̸գ�140801��������䣺data(:,i) = obj.(headers{i});
% �̸գ�140805����ǿ��ǰ�����������headers������ȡobj.headers


%% ǰ����
% Ĭ��������10����Ҫ
default_headers = {'time', ...
        'time2', ...
        'open',  ...
        'high', ...
        'low', ...
        'close', ...
        'vwap', ...
        'volume', ...      
        'amount', ...
        'openInt'};
if size(default_headers, 2) == 1
    default_headers = transpose(default_headers);
end

if ~exist('headers', 'var'),  
    if isempty(obj.headers)
        headers = default_headers;
    else
        headers = obj.headers;
    end    
end     
    
    
    %% ʱ��������Ϣ����Ϊ��������obj.data
len     = size(obj.time,1);
data    = nan(len,length(headers));

for i = 1:length(headers)
    try
        data(:,i) = obj.(headers{i});
    catch e
        disp( [headers{i} '����'] );
    end
end

obj.data    = data;   
obj.headers = headers;


%% data2 ��ű�����Ϣ
fields = {'code','code2','type','slicetype','latest'};
for i = 1:length(fields)
    f = fields{i};  
    v = obj.(f);
    data2{i,1} = f;
    data2{i,2} = v;
end

i = i+1;
data2{i,1} = 'sdt';
data2{i,2} = datestr(min(obj.time));

i = i+1;
data2{i,1} = 'edt';
data2{i,2} = datestr(max(obj.time));


obj.data2 = data2;

end

