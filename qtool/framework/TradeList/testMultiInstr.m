% ���䳬�� 20140706�� V1.0
% ʾ��һ�����в�ͬ��ĵ�tradeList�Ĳ�������

clear;
clc;
%%
addpath(genpath('V:\root\qtool\framework'));
load StocktestPack;
%��ʼ�ʽ�
config.initNav = 0;
% ��Լ����
config.instrType = [1,2];
% ��Լ����
config.instrID = {'a','b'};
% ��������
config.cmsnRate = [0.0001,0.0001];
% ��֤�����
config.marginRate = [1,1];
% ��Լ����
config.multiplier = [100,100];
% ����۸�
config.settlePrice = [0,0];
% ����ʱ��
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
% title('��λ');
% pause;
% close;
% plot(x.cumPnlArr);
% title('�ۼ����棬����');
% pause;
% close;
% plot(x.cumCmsnArr);
% title('�ۼ�Ӷ�𣬷���');
% pause;
% close;
% plot(x.maxPosArr);
% title('����λ������');
% pause;
% close;
% plot(x.frozenMarginArr);
% title('�����ʽ𣬷���');
% pause;
% close;
% plot(x.cumPnlVec);
% title('�ۼ�����');
% pause;
% close;
% plot(x.cumCmsnVec);
% title('�ۼ�Ӷ��');
% pause;
% close;
% plot(x.frozenMarginVec);
% title('�����ʽ�');
% pause;
% close;
% bar(y.data(:,y.pnlI));
% title('�ֱʽ���ӯ��');
% pause;
% close;
% bar(y.data(:,y.cmsnI));
% title('�ֱʽ���Ӷ��');
% pause;
% close;
% bar(y.data(:,y.spanI));
% title('�ֱʽ��׳ֲ�ʱ��');
% pause;
% close;
% bar(w.pnl);
% title('�غϽ���ӯ��');
% pause;
% close;
% bar(w.commission);
% title('�غϽ���Ӷ��');
% pause;
% close;
% bar(w.volume);
% title('�غϽ�����');
% pause;
% close;
% bar(w.span);
% title('�غϽ��׳ֲ�ʱ��');
% 
% 

