% 潘其超， 20140706， V1.0
% 示范一个含有不同标的的tradeList的操作过程

clear;
clc;
%%
addpath(genpath('V:\root\qtool\framework'));
load StocktestPack;
%初始资金
config.initNav = 0;
% 合约种类
config.instrType = [1,2];
% 合约代码
config.instrID = {'a','b'};
% 手续费率
config.cmsnRate = [0.0001,0.0001];
% 保证金比率
config.marginRate = [1,1];
% 合约乘数
config.multiplier = [100,100];
% 结算价格
config.settlePrice = [0,0];
% 结算时间
config.settleTime = today;

tic
x = TsRslt(itime,tl,config);
x.calcPosTs(tl);
x.calcPnlTs(tl, price);
toc

tic
y = PairTradeList.PairTL(tl,config,itime,price);
toc

tic
z = TradeSum.calcByRound(y);
toc

w = y.sumRound();

y.plotLossRecover();
figure;
y.plotMaxPLossD();
figure;
y.plotMaxPProfitD();
figure;
y.plotProfitDrawback();
figure;
y.plotTradePnl();

y.findExtremeTrade(1);


% plot(x.posArr);
% title('仓位');
% pause;
% close;
% plot(x.cumPnlArr);
% title('累计收益，分列');
% pause;
% close;
% plot(x.cumCmsnArr);
% title('累计佣金，分列');
% pause;
% close;
% plot(x.maxPosArr);
% title('最大仓位，分列');
% pause;
% close;
% plot(x.frozenMarginArr);
% title('冻结资金，分列');
% pause;
% close;
% plot(x.cumPnlVec);
% title('累计收益');
% pause;
% close;
% plot(x.cumCmsnVec);
% title('累计佣金');
% pause;
% close;
% plot(x.frozenMarginVec);
% title('冻结资金');
% pause;
% close;
% bar(y.data(:,y.pnlI));
% title('分笔交易盈亏');
% pause;
% close;
% bar(y.data(:,y.cmsnI));
% title('分笔交易佣金');
% pause;
% close;
% bar(y.data(:,y.spanI));
% title('分笔交易持仓时间');
% pause;
% close;
% bar(w.pnl);
% title('回合交易盈亏');
% pause;
% close;
% bar(w.commission);
% title('回合交易佣金');
% pause;
% close;
% bar(w.volume);
% title('回合交易量');
% pause;
% close;
% bar(w.span);
% title('回合交易持仓时间');
% 
% 

