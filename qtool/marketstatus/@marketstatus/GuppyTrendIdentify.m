function [FluxInd, TrendInd] = GuppyTrendIdentify(bars, period1, period2, period3, period4, period5, tol)
% v1.0 Yang Xi
% 利用顾比ratio来进行趋势划分
% bars和5个period用来计算顾比ratio
% tol是调用ContinFilter趋势过滤时的容忍数目的最大值
% FluxInd返回bars的盘整阶段的序数
% TrendInd返回趋势阶段的序数
% 输入参数的参考值：对于分钟数据 period1 = 10,period2 = 20,period3 = 60,period4 = 120,
% period5 = 240, tol = 30~60
if ~exist('period1','var'), period1 = 10; end;
if ~exist('period2','var'), period2 = 20; end;
if ~exist('period3','var'), period3 = 60; end;
if ~exist('period4','var'), period4 = 120; end;
if ~exist('period5','var'), period5 = 240; end;
if ~exist('tol','var'), tol = 60; end;
GuppyRatio = marketstatus.GuppyMMA(bars, period1, period2, period3, period4, period5);
FluxThrshld = prctile(GuppyRatio,25);
Fluxsignal = (GuppyRatio<FluxThrshld);
[~, Trendsignal] = marketstatus.ContinFilter(1-Fluxsignal,tol); % 先对趋势信号进行过滤，类似于给盘整信号进行填补
NewFluxsignal = (Trendsignal == 0); 
[~, NewFluxsignal] = marketstatus.ContinFilter(NewFluxsignal,tol);% 对新的盘整信号进行过滤
FluxInd = find(NewFluxsignal == 1);
TrendInd = setdiff(1:length(bars.time),FluxInd);
end
