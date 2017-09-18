function [sig_long, sig_short,sig_rs] = Pvt(ClosePrice,Volume,nBar, type)
% Price Volume Trend 价量趋势指标

% PVT指标计算公式[1]
% 如果设x＝(今日收盘价—昨日收盘价)／昨日收盘价×当日成交量，
% 那么当日PVT指标值则为从第一个交易日起每日X值的累加。
% daniel 2013/4/2


%% 预处理
if ~exist('nBar', 'var'), nBar = 5; end
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
    sig_rs( ClosePrice > ind.ma(ClosePrice, nBar) & ind.roc(ClosePrice, nBar) > 0 & pvtVal > ind.ma(pvtVal, nBar)) = 1;
    sig_rs( ClosePrice < ind.ma(ClosePrice, nBar) & ind.roc(ClosePrice, nBar) < 0 & pvtVal < ind.ma(pvtVal,nBar)) = -1;
    sig_long (crossOver(ClosePrice, ind.ma(ClosePrice, nBar))  & ind.roc(ClosePrice, nBar) > 0 & pvtVal > ind.ma(pvtVal, nBar)) = 1;
    sig_short ( crossOver(ind.ma(ClosePrice, nBar), ClosePrice) & ind.roc(ClosePrice, nBar) < 0 & pvtVal < ind.ma(pvtVal,nBar)) = -1;
else
;
end %EOF



