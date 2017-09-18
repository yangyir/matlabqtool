function [sig_long, sig_short,sig_rs] = Pvt(ClosePrice,Volume, mu_up, mu_down,type)
% Price Volume Trend 价量趋势指标

% PVT指标计算公式[1]
% 如果设x＝(今日收盘价—昨日收盘价)／昨日收盘价×当日成交量，
% 那么当日PVT指标值则为从第一个交易日起每日X值的累加。
% daniel 2013/4/2


%% 预处理
if ~exist('mu_up', 'var') || isempty(mu_up), mu_up = 0.02; end
if ~exist('mu_down', 'var') || isempty(mu_down), mu_down = 0.02; end
if ~exist('type', 'var') || isempty(type), type = 1; end

[nPeriod, nAsset] = size(ClosePrice);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs   = zeros(nPeriod, nAsset);




%% 计算步
[pvtVal] = ind.pvt(ClosePrice,Volume);

%% 信号步
% 价格上升伴随PVT上升，确认价格上升。
% 价格下降伴随PVT下降，确认价格下降。
% 价格上升，但pvt下降，则上升趋势减弱。
% 价格下降，但pvt上升，则下降趋势减弱。
if type==1
for i = 1: nAsset
[closeHigh, closeLow, closeStat] = LastExtrema(ClosePrice(:,i),mu_up, mu_down);
[pvtHigh,   pvtLow,   pvtStat] = LastExtrema(pvtVal(:,i), mu_up, mu_down);
sig_rs(closeStat== 1 & pvtStat== 1  ,i) = 1;
sig_rs(closeStat==-1 & pvtStat==-1  ,i) =-1;
sig_long(pvtVal(:,i) > pvtHigh  & ClosePrice(:,i)< closeHigh)=1;
sig_short(pvtVal(:,i) <pvtLow  & ClosePrice(:,i) > closeLow) =-1;
end
else
;
end %EOF



