%%
%���νű�
%By Zehui Wu,version 1.0,2013/7/2

%%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%
%����Դ
dataname = '';
%���ײ���
configure.cost = 0.0003;
configure.leverage = 3;
configure.lag = 1;
configure.initValue = 1e5;
configure.multiplier = 300;
configure.marginRate = 0.12;
configure.riskfreebench = 0.03;
configure.varmethod = 1;
configure.vara = 0.05;
configure.riskIndex = 1;
configure.orderStyle = 1;
% %�зֲ���
% uppercent = 0.02;
% downpercent = 0.02;
% tol1 = ;
% tol2 = ;

%�źŲ���
short = 12;
long = 26;
compare = 9;
type = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����bars����
bars = importdata(dataname);

% �����ƽ����з֣��õ�index
% %���������з�
% [UpInd,DownInd,FluxInd] = marketstatus.ContinTrendIdentify(bars, tol1, uppercent, downpercent, tol2);
% %�������Ƶĵ��µ�bars����
% barsup = marketstatus.BarsSplit(bars,UpInd);
% barsdown = marketstatus.BarsSplit(bars,DownInd);
% barsflux = marketstatus.BarsSplit(bars,FluxInd);

% �˱��з�
[FluxInd, TrendInd] = GuppyTrendIdentify(bars);
barsTrend = marketstatus.BarsSplit(bars,TrendInd);
%����tai2����ĺ����õ�ԭʼ�ź�
[sig_long,sig_short,~] = Macd(barsTrend,short,long,compare,type);
%
sig_pos_Trend = trade2pos(sig_long(TrendInd), sig_short(TrendInd));
%�µĲ�λ�ź���sig_posÿ�������Ϊ0
EndInd = find((TrendInd(2:end)-TrendInd(1:end-1))>=2);
sig_pos_Trend(EndInd) = 0;
%�ز�������
backtest_result = backtestF(sig_pos_Trend,barsTrend, configure);
%%