% ���䳬�� 20140706�� V1.0
% ʾ��һ������tradeList�Ĳ������̣���Ҫ��Ϊ������Ч�ʡ�


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
% TL2.volume(1) = 2;

for i= 1:7
    TL2.add(TL2);
end

iTime = [dayTick2.time;dayTick2.time+1;dayTick2.time+2];
price = repmat(dayTick2.last,3,1);

tic
x = TsRslt(iTime,TL2,config);
x.calcPosTs(TL2);
x.calcPnlTs(TL2, price);
toc

tic
y = PairTradeList.PairTL(TL2,config,iTime,price);
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
plotTradeMap2(y,x,price);

