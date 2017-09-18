%%
%调参脚本
%By Zehui Wu,version 1.0,2013/7/2

%%%%%%%%%%%%输入参数%%%%%%%%%%%%%%%%%%%%
%数据源
dataname = '';
%交易参数
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
% %切分参数
% uppercent = 0.02;
% downpercent = 0.02;
% tol1 = ;
% tol2 = ;

%信号参数
short = 12;
long = 26;
compare = 9;
type = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输入bars数据
bars = importdata(dataname);

% 对走势进行切分，得到index
% %连涨连跌切分
% [UpInd,DownInd,FluxInd] = marketstatus.ContinTrendIdentify(bars, tol1, uppercent, downpercent, tol2);
% %三种趋势的到新的bars数据
% barsup = marketstatus.BarsSplit(bars,UpInd);
% barsdown = marketstatus.BarsSplit(bars,DownInd);
% barsflux = marketstatus.BarsSplit(bars,FluxInd);

% 顾比切分
[FluxInd, TrendInd] = GuppyTrendIdentify(bars);
barsTrend = marketstatus.BarsSplit(bars,TrendInd);
%调用tai2里面的函数得到原始信号
[sig_long,sig_short,~] = Macd(barsTrend,short,long,compare,type);
%
sig_pos_Trend = trade2pos(sig_long(TrendInd), sig_short(TrendInd));
%新的仓位信号中sig_pos每段最后置为0
EndInd = find((TrendInd(2:end)-TrendInd(1:end-1))>=2);
sig_pos_Trend(EndInd) = 0;
%回测结果计算
backtest_result = backtestF(sig_pos_Trend,barsTrend, configure);
%%