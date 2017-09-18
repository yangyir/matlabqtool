% 潘其超， 20140706， V1.0
% 示范一个大型tradeList的操作过程，主要是为了评估效率。


clear;
clc;
%%
addpath(genpath('V:\root\qtool\framework'));
load IFtestPack;

%初始资金
config.initNav  = 0;
% 合约种类
config.instrType = 0;
% 合约代码
config.instrID = {'a'};
% 手续费率
config.cmsnRate = 0.0001 ;
% 保证金比率
config.marginRate =  0.12;
% 合约乘数
config.multiplier = 300;
% 结算价格
config.settlePrice = 2100;
% 结算时间
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

