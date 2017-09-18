% ���䳬��20140701��V.10
% ʾ��һ����TradeList�ķ������̡�

clear;
clc;
%%
addpath(genpath('V:\root\qtool\framework'));

load IFtestPack;

%��ʼ�ʽ�
config.initNav  = 0;
% ��Լ����
config.instrType = 0;
% ��Լ����
config.instrID = {'a'};
% ��������
config.cmsnRate = 0.0001 ;
% ��֤�����
config.marginRate =  0.12;
% ��Լ����
config.multiplier = 300;
% ����۸�
config.settlePrice = 2100;
% ����ʱ��
config.settleTime = today;

%����to Excel
% TL2.toExcel();

% TL2 = TradeList();
% ���ڻز������TradeList�����Ҫ����Ӷ����Ҫ��tradeID����Ϊһ�����������С�
TL2.sortByTime();
tic
x = TsRslt(dayTick2.time,TL2,config);
x.calcPosTs(TL2);
x.calcPnlTs(TL2, dayTick2.last);
toc

tic
y = PairTradeList.PairTL(TL2,config,dayTick2.time,dayTick2.last);
toc

tic
z = TradeSum.calcByRound(y);
toc

w = y.sumRound();

figure;
x.plotNavVec();
figure;
y.plotLossRecover();
figure;
y.plotMaxPLossD();
figure;
y.plotMaxPProfitD();
figure;
y.plotProfitDrawback();
figure;
y.plotTradePnl();
figure;
plotTradeMap2(y,x,dayTick2.last);