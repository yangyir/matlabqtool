function [ aimDate ] = nthWeekdayOfMonth( n, wkday, mm, yyyy )
%NTHWEEKDAYOFMONTH yyyymm月的第n个星期k
% 特别注意，weekday使用 1-Sun ... 7-Sat ( LOCALE == en )
% 程刚;140616

%% 预处理
if ~exist('yyyy', 'var'),   yyyy = year(now); end
if ~exist('mm', 'var'),     mm = month(now); end

if isa(yyyy, 'char')
    yyyy = str2double(yyyy);
    if yyyy < 100
        yyyy = 2000+yyyy;
    end
end

if isa(mm, 'char')
    mm = str2double(mm);
    if mm<0 || mm>12
        disp('错误：mm应为 1 - 12 ');
        return;
    end
end


if isa(wkday, 'double')
    k = floor(wkday); %直接就是数字了
    if k>7 || k<=0
        disp('错误: weekday 应为 1 - 7');
        return;
    end
end

if isa(wkday, 'char')
    switch wkday
        case{'Sun', 'sun', 'Sunday', 'sunday'}
            k = 1;
        case{ 'Mon', 'mon'}
            k = 2;
        case{'Tue', 'tue'}
            k = 3;
        case{'Wed', 'wed'}
            k = 4;
        case{'Thu', 'thu'}
            k = 5;
        case{'Fri', 'fri'}
            k = 6;
        case{'Sat', 'sat'}
            k = 7;
        otherwise
            fprintf('错误：weekday = %s 不可识别', wkday);
            return;            
    end
end
               
if n>5
    disp('错误：n > 5 ');
    return;
end



%% main
firstDay = datenum(yyyy,mm,1);

[d,w] = weekday(firstDay);

% 还没过第一个k日
aimDate = firstDay + (n-1)*7 + (k-d);

% 本周的k日已过，本月第一个k日要在下周
if k < d
    aimDate = aimDate + 7;
end

% 应该还要check一下是否还在这个月内，否则出错
if mm < month(aimDate)
    disp('警告：结果已超过本月');
end




end

