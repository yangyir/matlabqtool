function [  ] = demo(  )
%DEMO Summary of this function goes here
%   Detailed explanation goes here

clear all; rehash

%% 生成一个entrust

e = Entrust;

e.volume = -3; % 应该失败
e.direction = '2'  % 应自动转成 -1

marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;

e.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount)
e.date = today;     e.date2 = datestr(e.date);
e.time = now;       e.time2 = datestr(e.time);

% 输出
e.println;

%% 把单子下出去，取得entrustNo
% 下单
d = e.get_CounterHSO32_direction;


% 回报
e.entrustNo = 112233;

% 输出
e.println;

%% 把成交反馈填入entrust
% e.fill_entrust_query_packet_HSO32(packet)
e.dealVolume = 200;
e.dealPrice = 1.19;
e.dealAmount = 238;



%% 输出
e.println;

e.is_entrust_closed


end

