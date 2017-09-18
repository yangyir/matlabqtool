function [ data, headers ] = toTable( obj, headers )
%TOTABLE 矩阵输出时间序列，存在TEBase.data, TEBase.headers里
% 原TradeList和EntrustList中单独的域和方法统一到这个
% 可供输出excel用。Ticks,Bars,TradeList里也有同样的函数
% headers的优先级：入参里 > obj.headers > default_headers(主要域都含）
% ===============================================================
% 程刚，140805

%% 预处理

% 所有域全包含
all_fields = properties( obj );

% 选出所有N*1向量域， 所有标量域
default_headers  = {};  % 所有N*1向量域
default_headers2 = {}; % 所有标量域，暂时不用
lenN             = size(obj.time, 1);
for i = 1:length(all_fields)
    f   = all_fields{i};
    s1  = size( obj.(f), 1);
    s2  = size( obj.(f), 2);
    
    % 所有N*1向量域
    if s1 == lenN && s2 == 1
        default_headers{end+1} = f;
    end
    
    % 所有标量域
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


%% 时间序列向量， 放入data
data    = nan(lenN, length(headers));

for i = 1:length(headers)
    f = headers{i};
    try
        data(:,i) = obj.(f);
    catch e
        disp( [f '出错！'] );
    end
end

obj.data    = data;
obj.headers = headers;

%% 信息标量, 放入data2（暂无）




end


