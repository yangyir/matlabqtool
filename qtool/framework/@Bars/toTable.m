function [ data, headers, data2] = toTable( obj, headers )
% 把bars中的数据放进一个matrix里，存于obj.data, obj.header
% Ticks也有此函数
% headers的优先级：入参 > obj.headers > default_headers(主要域都含）
% ===============================================================
% 程刚，20131211
% 程刚，140801，改了这句：data(:,i) = obj.(headers{i});
% 程刚，140805，加强了前处理，允许入参headers，允许取obj.headers


%% 前处理
% 默认至少这10个域都要
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
    
    
    %% 时间序列信息，化为矩阵，填入obj.data
len     = size(obj.time,1);
data    = nan(len,length(headers));

for i = 1:length(headers)
    try
        data(:,i) = obj.(headers{i});
    catch e
        disp( [headers{i} '出错！'] );
    end
end

obj.data    = data;   
obj.headers = headers;


%% data2 存放标量信息
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

