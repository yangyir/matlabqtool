%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算日收益率序列。
% 隔夜风险计算在下一天。即：
% 第一天的收益为：
% （第一天结束-第一天开始）/第一天开始
% 第二天以后的日收益为：
% （当日结束-上日结束）/上日结束
% 如果两日之间相隔数日，间隔风险都算在下一日开头。
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function returns = calc_series_returns(account,times)
startDay = floor(times(1));
endDay = floor(times(end));
if startDay == endDay
    returns = [startDay,account(end)/account(1)-1];
else
    days = floor(times);   
    dDays = diff(days);
    dayMark = find(dDays);
    dayMark = [1;dayMark;length(times)];
    dayYield = account(dayMark(2:end))./account(dayMark(1:end-1))-1;
    returns = [days(dayMark(2:end)),dayYield];
    
end

end