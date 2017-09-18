function [mx,tk,t] = maxof( ticks, currentTk, len, type)
%MAXOF       δ��һ��ʱ���ڵ����ֵ����λ��
% @luhuaibao
% 2014.6.4
% inputs:
%       ticks,    Ticks��
%       currentTk, ������
%       type,  ��ѡ�񣬰���'last'(Ĭ�ϣ�,'bid','ask' 
% outputs:
%       tk,         δ��len��tick�ڣ����ֵ����λ�ã����ѵ�ǰ���룻��ǰλ�ÿ�����Ϊ0
%       t,          ��tk��Ӧ��ת��Ϊs
%       mx,         ��Ӧ�����ֵ


if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
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

% ������磬��ȥ����90����
if t1-floor(t1) <= 11.5/24
    if t2 - floor( t2 ) >= 13/24
        t = t - 1.5/24;
    end
end

t = t*24*3600 ; 




end

