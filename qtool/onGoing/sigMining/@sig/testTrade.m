function [result, TL] = testTrade(obj, param)
% default param of trade
% 为调用tradelist作准备
% %初始资金
% param.initNav  = 0;
% % 合约种类
% param.instrType = 0;
% % 合约代码
% param.instrID = {'a'};
% % 手续费率
% param.cmsnRate = 0.0001 ;
% % 保证金比率
% param.marginRate =  1;
% % 合约乘数
% param.multiplier = 1;
% % 结算价格
% param.settlePrice = 2100;
% % 结算时间
% param.settleTime = today;

%---------------------
% huajun @20140910

tradeNum = size(obj.entry,1)*2;
TL = TradeList(tradeNum);
TL.time = [obj.entry(:,2); obj.exit(:,2)];
TL.strategyNo = [obj.entry(:,5); obj.exit(:,5)];
TL.direction = sign([obj.entry(:,4);obj.exit(:,4)]);
TL.volume = abs([obj.entry(:,4);obj.exit(:,4)]);
TL.price = [obj.entry(:,3);obj.exit(:,3)];
TL.tradeID = ones(length(obj.entry)+length(obj.exit),1);

TL.latest = tradeNum;
TL.prune;
TL.sortByTime();

result = TsRslt( obj.time, TL, param);
result.calcPosTs(TL);
result.calcPnlTs(TL, obj.bid);

