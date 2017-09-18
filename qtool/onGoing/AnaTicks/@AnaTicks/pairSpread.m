function [ spread0, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime)
%PAIRSPREAD 算两个ticks之间的配对spread，ticks1-ticks2
% [ spread0, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime) 输入：
%   type          1-限价单（默认，bid1，ask1）;  2-市价单，last相减，要额外算slippage
%   timeType      时间对齐的方式，
%                     0-不活跃ticks时间（默认），
%                     1-ticks1时间，
%                     2-ticks2时间，
%                     3-union
%                     4-intersect
%                     9-自己给入参
%   commonTime    对齐后的时间序列， 可以自己给，配合timeType==9用
% 输出：
%     spread0     以0为分界线的spread，之上（卖）取bid，之下（买）取ask
%     spTicks     Ticks类型的spread，时间用commonTime，交易量用小，ask用ticks1.ask-ticks2.bid，bid类似
% 程刚，140610
% 程刚，140723；增加了timeType

%% 预处理
if ~isa(ticks1, 'Ticks') || ~isa(ticks2,'Ticks')
    disp('错误：数据类型要是Ticks');
    return;
end

if ~exist('type', 'var') 
    type = 1;
end

if ~exist('timeType', 'var')
    timeType  = 0;
end
  
if timeType ==9 && ~exist('commonTime', 'var')
    disp('错误：未给出commonTime(timeType == 9), 重置timeType=0');
    timeType = 0;
end

%% 时间对齐是个大问题!! 还要斟酌

if ticks1.date ~= ticks2.date
    disp('注意：ticks1.date ~= ticks2.date');
end

    
% 不应该只取到秒，日期也该看
% times1 = ticks1.time - floor(ticks1.time);
% times2 = ticks2.time - floor(ticks2.time);
times1 = ticks1.time;
times2 = ticks2.time;


% 用什么作commonTime？ 很头疼
switch timeType
    case {0} % 谁时间少/交易不活跃，向谁看齐
        if ticks1.amount(ticks1.latest) > ticks2.amount( ticks2.latest )
            commonTime = times2;
        else
            commonTime = times1;
        end
        
    case 1 %向ticks1的时间对齐
        commonTime = times1;
    case 2 % 向ticks2的时间对齐
        commonTime = times2;
    case 3 % union时间
        commonTime = union(times1, times2);
    case 4 % intersect时间
        commonTime = intersect(times1, times2);    
    case 9 % 入参已给一个commonTime       
        
end

% commonTime 头和尾不能超出
commonTime = commonTime( commonTime>=times1(1) & commonTime>=times2(1) );
commonTime = commonTime( commonTime<=times1(end) & commonTime<=times2(end));



[ idx1, idx2 ] = duiqiTime( times1, times2, 'given', commonTime );


if length(idx1) ~= length(idx2)
    disp('错误：时间没有对齐');
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



%% 以0为界的交易策略下，看这条线最靠谱
spread0 = zeros(length(idx1),1);
switch(type)
    case 1
        spread0(sp_ask<0) = sp_ask(sp_ask<0);
        spread0(sp_bid>0) = sp_bid(sp_bid>0);
    case 2
        spread0 = sp_last;
    otherwise
        disp('错误：未知type');
        return;
end



end

