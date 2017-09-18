function [ n ] = daysNonWeekend( date1, date2 )
%DAYSNONWEEKEND 计算两个时间之间的间隔
% date1, date2 用double日期
% 程刚；140617

%% 预处理

% 如是字符串，换成数字
if isa(date1, 'char') || isa(date2, 'char')
    disp('错误：date1, date2日期用double类');
    return;
end


% date2 大， date1 小
if date2 < date1
    tmp = date1;
    date1 = date2;
    date2 = tmp;
end



%% main
% 1-Sun, 7-Sat
w1 = weekday(date1, 'en_US');
w2 = weekday(date2, 'en_US');


% 有多少整周
n_weeks = floor((date2 - date1)/7);


% 零碎天数中，有多少工作日
if w1 == w2
    rem_days = 0;
elseif w1 < w2
    rem_days = nnz(w1+1:w2 > 1 & w1+1:w2 < 7);
elseif w1 > w2
    rem_days = max((6-w1),0)  + (w2-1);
end

% 总数
n = n_weeks * 5 + rem_days;

end

