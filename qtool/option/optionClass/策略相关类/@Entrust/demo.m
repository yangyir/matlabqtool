function [  ] = demo(  )
%DEMO Summary of this function goes here
%   Detailed explanation goes here

clear all; rehash

%% ����һ��entrust

e = Entrust;

e.volume = -3; % Ӧ��ʧ��
e.direction = '2'  % Ӧ�Զ�ת�� -1

marketNo = '1';
stockCode = 510050;
entrustDirection = 1;
entrustPrice = 1.2;
entrustAmount = 200;

e.fillEntrust(marketNo, stockCode,entrustDirection,entrustPrice,entrustAmount)
e.date = today;     e.date2 = datestr(e.date);
e.time = now;       e.time2 = datestr(e.time);

% ���
e.println;

%% �ѵ����³�ȥ��ȡ��entrustNo
% �µ�
d = e.get_CounterHSO32_direction;


% �ر�
e.entrustNo = 112233;

% ���
e.println;

%% �ѳɽ���������entrust
% e.fill_entrust_query_packet_HSO32(packet)
e.dealVolume = 200;
e.dealPrice = 1.19;
e.dealAmount = 238;



%% ���
e.println;

e.is_entrust_closed


end

