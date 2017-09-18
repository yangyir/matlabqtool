function [t, tk] = minSince( ticks, currentTk, type)
%MINSINCE       当前价格是多长过去时间的最小值
% @luhuaibao
% 2014.6.3
% inputs:
%       ticks,    Ticks类
%       currentTk, 正整数
%       type,  供选择，包括'last','bid','ask' 
% outputs:
%       tk,         把当前tick记入，即tk的最小值也会是1，这与实际情况相符，tick也可看作一个切片
%       t,          单位,s


if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end
 
if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 


switch type
    case 'last'
        data = ticks.last(1:n);
    case 'bid'
        data = ticks.bidP(1:n,1);
    case 'ask'
        data = ticks.askP(1:n,1);    
end ;  

if currentTk == 1
    tk = 1 ; 
    t = 0 ; 
    return ; 
end ; 


currentPrice = -data(currentTk); 

ts = -data(1:currentTk-1) ; 

tk = find(ts>=currentPrice,1,'last');
if isempty(tk)
    tk = 0 ; 
end ; 

% tk
tk = currentTk - tk ; 

% time
t1 = ticks.time(max(1,currentTk - tk) ) ; 
t2 = ticks.time(currentTk) ; 
t = t2 - t1 ;

% 如果跨午，减去中午90分钟
if t1-floor(t1) <= 11.5/24
    if t2 - floor( t2 ) >= 13/24
        t = t - 1.5/24;
    end
end

t = t*24*3600 ; 




end

