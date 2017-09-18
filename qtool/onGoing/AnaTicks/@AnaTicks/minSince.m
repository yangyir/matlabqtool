function [t, tk] = minSince( ticks, currentTk, type)
%MINSINCE       ��ǰ�۸��Ƕ೤��ȥʱ�����Сֵ
% @luhuaibao
% 2014.6.3
% inputs:
%       ticks,    Ticks��
%       currentTk, ������
%       type,  ��ѡ�񣬰���'last','bid','ask' 
% outputs:
%       tk,         �ѵ�ǰtick���룬��tk����СֵҲ����1������ʵ����������tickҲ�ɿ���һ����Ƭ
%       t,          ��λ,s


if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
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

% ������磬��ȥ����90����
if t1-floor(t1) <= 11.5/24
    if t2 - floor( t2 ) >= 13/24
        t = t - 1.5/24;
    end
end

t = t*24*3600 ; 




end

