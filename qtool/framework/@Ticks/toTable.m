function [data, headers, data2] = toTable( obj, headers )
%TOTABLE 矩阵输出时间序列，存在ticks.data, ticks.headers里
% 可供输出excel用。Bars里也有同样的函数
% headers的优先级：入参里 > obj.headers > default_headers(主要域都含）
% ===============================================================
% 程刚，140709
% 程刚，140801，
%         现：date(:,i) = obj.(headers{i});
%         原eval( [ 'data(:,i) = obj.' headers{i} ';']  );
%         效率没有提高，也没降低
% 程刚，140805，加强了前处理，允许入参headers，允许取obj.headers



%% 前处理
% 至少这6个域都要
default_headers = {'time', ...
        'time2', ...
        'last', ...
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
    
%% data    
len     = size(obj.time,1);
data    = nan(len,length(headers));
 
for i = 1:length(headers)
    f = headers{i};
    try
        data(:,i) = obj.(f);
    catch e
        disp( [f '出错！'] );
    end
end



%% bid, ask 放入data，非一维，要处理

fields = {'bidP', 'bidV', 'askP', 'askV'};
for ifd = 1:4
    f  = fields{ifd};
    try
        levels = size(obj.(f), 2);
        for ilv = 1:levels
            headers{end+1} = [f num2str(ilv) ];
        end
        data(:, (end+1):(end+levels)) = obj.(f);
    catch e
        fprintf('%s出错', f);
    end
end


    

%% data2 存放标量信息
fields = {'code','code2','type','levels','latest'};
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




%% 
obj.data    = data;   
obj.headers = headers;
obj.data2   = data2;



end

