function [mx,tk,t] = maxof( ticks, currentTk, len, type)
%MAXOF       未来一段时间内的最大值，及位置
% @luhuaibao
% 2014.6.4
% inputs:
%       ticks,    Ticks类
%       currentTk, 正整数
%       type,  供选择，包括'last'(默认）,'bid','ask' 
% outputs:
%       tk,         未来len个tick内，最大值所处位置，不把当前计入；当前位置可以视为0
%       t,          与tk对应，转化为s
%       mx,         对应的最大值


if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end
 
if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 

if ~exist('type', 'var'), type = 'last'; end

switch type
    case 'last'
        data = ticks.last(1:n);
    case 'bid'
        data = ticks.bidP(1:n,1);
    case 'ask'
        data = ticks.askP(1:n,1);    
end ;  


maxlen = min(currentTk+len,n) ; 

ts = data( currentTk+1:maxlen ) ; 

[mx,tk] = max(ts) ;  

% time
t1 = ticks.time( currentTk ) ; 
t2 = ticks.time(currentTk+tk) ; 
t = t2 - t1 ;

% 如果跨午，减去中午90分钟
if t1-floor(t1) <= 11.5/24
    if t2 - floor( t2 ) >= 13/24
        t = t - 1.5/24;
    end
end

t = t*24*3600 ; 




end

