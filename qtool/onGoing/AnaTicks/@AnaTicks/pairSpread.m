function [ spread0, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime)
%PAIRSPREAD ������ticks֮������spread��ticks1-ticks2
% [ spread0, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime) ���룺
%   type          1-�޼۵���Ĭ�ϣ�bid1��ask1��;  2-�м۵���last�����Ҫ������slippage
%   timeType      ʱ�����ķ�ʽ��
%                     0-����Ծticksʱ�䣨Ĭ�ϣ���
%                     1-ticks1ʱ�䣬
%                     2-ticks2ʱ�䣬
%                     3-union
%                     4-intersect
%                     9-�Լ������
%   commonTime    ������ʱ�����У� �����Լ��������timeType==9��
% �����
%     spread0     ��0Ϊ�ֽ��ߵ�spread��֮�ϣ�����ȡbid��֮�£���ȡask
%     spTicks     Ticks���͵�spread��ʱ����commonTime����������С��ask��ticks1.ask-ticks2.bid��bid����
% �̸գ�140610
% �̸գ�140723��������timeType

%% Ԥ����
if ~isa(ticks1, 'Ticks') || ~isa(ticks2,'Ticks')
    disp('������������Ҫ��Ticks');
    return;
end

if ~exist('type', 'var') 
    type = 1;
end

if ~exist('timeType', 'var')
    timeType  = 0;
end
  
if timeType ==9 && ~exist('commonTime', 'var')
    disp('����δ����commonTime(timeType == 9), ����timeType=0');
    timeType = 0;
end

%% ʱ������Ǹ�������!! ��Ҫ����

if ticks1.date ~= ticks2.date
    disp('ע�⣺ticks1.date ~= ticks2.date');
end

    
% ��Ӧ��ֻȡ���룬����Ҳ�ÿ�
% times1 = ticks1.time - floor(ticks1.time);
% times2 = ticks2.time - floor(ticks2.time);
times1 = ticks1.time;
times2 = ticks2.time;


% ��ʲô��commonTime�� ��ͷ��
switch timeType
    case {0} % ˭ʱ����/���ײ���Ծ����˭����
        if ticks1.amount(ticks1.latest) > ticks2.amount( ticks2.latest )
            commonTime = times2;
        else
            commonTime = times1;
        end
        
    case 1 %��ticks1��ʱ�����
        commonTime = times1;
    case 2 % ��ticks2��ʱ�����
        commonTime = times2;
    case 3 % unionʱ��
        commonTime = union(times1, times2);
    case 4 % intersectʱ��
        commonTime = intersect(times1, times2);    
    case 9 % ����Ѹ�һ��commonTime       
        
end

% commonTime ͷ��β���ܳ���
commonTime = commonTime( commonTime>=times1(1) & commonTime>=times2(1) );
commonTime = commonTime( commonTime<=times1(end) & commonTime<=times2(end));



[ idx1, idx2 ] = duiqiTime( times1, times2, 'given', commonTime );


if length(idx1) ~= length(idx2)
    disp('����ʱ��û�ж���');
    return;
end



%% Main

sp_ask = ticks1.askP(idx1,1) - ticks2.bidP(idx2,1);
sp_bid = ticks1.bidP(idx1,1) - ticks2.askP(idx2,1);
sp_last = ticks1.last(idx1) - ticks2.last(idx2);
vo1 = ticks1.volume(idx1);
vo2 = ticks2.volume(idx2);
dvo1 = [vo1(1); diff(vo1)];
dvo2 = [ vo2(1); diff(vo2) ] ;
sp_dvo = min( [dvo1, dvo2], [],2);
sp_volume = cumsum(sp_dvo);


spTicks = Ticks;

spTicks.code2   = [ticks1.code '-' ticks2.code];
spTicks.type    = 'spread';
spTicks.time    = commonTime;
spTicks.time2   = datestr(commonTime, 'hhmmssfff');
spTicks.date    = ticks1.date;
spTicks.date2   = datestr(spTicks.date);
spTicks.latest  = 0;

spTicks.last    = sp_last;
spTicks.askP    = sp_ask;
spTicks.bidP    = sp_bid;
spTicks.volume  = sp_volume;
spTicks.askV    = min( [ticks1.askV(idx1, 1), ticks2.bidV(idx2,1)], [], 2);
spTicks.bidV    = min( [ticks1.bidV(idx1, 1), ticks2.askV(idx2,1)], [], 2);



%% ��0Ϊ��Ľ��ײ����£������������
spread0 = zeros(length(idx1),1);
switch(type)
    case 1
        spread0(sp_ask<0) = sp_ask(sp_ask<0);
        spread0(sp_bid>0) = sp_bid(sp_bid>0);
    case 2
        spread0 = sp_last;
    otherwise
        disp('����δ֪type');
        return;
end



end

