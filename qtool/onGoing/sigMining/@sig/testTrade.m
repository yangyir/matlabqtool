function [result, TL] = testTrade(obj, param)
% default param of trade
% Ϊ����tradelist��׼��
% %��ʼ�ʽ�
% param.initNav  = 0;
% % ��Լ����
% param.instrType = 0;
% % ��Լ����
% param.instrID = {'a'};
% % ��������
% param.cmsnRate = 0.0001 ;
% % ��֤�����
% param.marginRate =  1;
% % ��Լ����
% param.multiplier = 1;
% % ����۸�
% param.settlePrice = 2100;
% % ����ʱ��
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

