function [ newbars ] = getcut( obj, times,  flag )
%UNTITLED 截断原bars作为newbars
% [ newbars ] = getcut( obj, times )
%   times        两种格式，如果对时间要求不高，输入格式为[3：200]，指定切出3：200行。
%                如果对时间精度要求高，输入格式为[20130101，20130801]，指定输出2013年1月1日至2013年8月1日的数据
%   flag         如果是格式1，flag为1；如果是格式2，flag为2
% -------------------------------------------
% ver1.0; Zhang,Hang;
% ver1.1; Cheng,Gang; 20130420; 加强注释，修改变量名
% ver1.2; Lu, Huaibao ; 20130927; 增加切分方式，除了指定行数外，可指定具体日期格式的时间段。



% -----------------------------------以下为20130927加入部分------------------------
switch flag
    case 1
        times = times; 
    case 2
        var0 = times(1);
        var1 = times(2);
        var0 = num2str(var0);
        var0 = datenum(var0,'yyyymmdd');
        var1 = num2str(var1);
        var1 = datenum(var1,'yyyymmdd');
        var2 = obj.time;
        var2 = floor(var2);
        id0 = find( var2 >= var0, 1, 'first');
        id1 = find( var2 <= var1, 1, 'last');
        times = id0:id1;
end;
% -----------------------------------以上为20130927加入部分------------------------


newbars = Bars;

fields = fieldnames(obj);

for i = 1:length(fields)
    eval(['newbars.', fields{i}, '=copyval(obj.', fields{i}, ', times);']);
end

newbars = newbars.autocalc();
        
function b = copyval(a, times)
if ~isempty(a)
    if isvector(a) && length(a) >= length(times)
        b = a(times);
    else
        b = a;
    end
else
    b = [];
end

