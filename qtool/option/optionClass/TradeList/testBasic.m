% 潘其超，20140701，V.10
% 示范一个简单TradeList的分析过程。

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

%测试to Excel
% TL2.toExcel();

% TL2 = TradeList();
% 对于回测产生的TradeList，如果要计算佣金，需要将tradeID设置为一个正整数序列。
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