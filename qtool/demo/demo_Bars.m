%% ȡ����
load('Y:\qdata\IF\intraday_bars_300s_daily\IF0Y00_20130306.mat');
b = IF0Y00_20130306

%% ����K��ͼ
b.plot;

%% ����������
% ����workspace�￴һ��b��Ӧ��û����������
% ִ��autocalc�󣬾�������������
b = b.autocalc

%% ��ʾָ��λ��

% ����showplace����
len = length(b.close);
showplace = rands(len);

% ֻ���ʾ�����е� >0 ��λ�ã��������ֲ���
b.plotind( showplace )
