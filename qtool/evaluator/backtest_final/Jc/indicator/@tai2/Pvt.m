function [sig_long, sig_short,sig_rs] = Pvt(bar, nBar, type)
% Price Volume Trend 价量趋势指标
%
% PVT指标计算公式[1]
% 如果设x＝(今日收盘价—昨日收盘价)／昨日收盘价×当日成交量，
% 那么当日PVT指标值则为从第一个交易日起每日X值的累加。


%% 预处理
ClosePrice = bar.close;
Volume = bar.volume;
if ~exist('nBar', 'var'), nBar = 5; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算步
[sig_long, sig_short, sig_rs] = tai.Pvt( ClosePrice, Volume, nBar, type);

if nargout == 0
    pvt.pvt = ind.pvt(ClosePrice, Volume);
    bar.plotind2(sig_long + sig_short, pvt, true);
    title('pvt long and short');
    bar.plotind2(sig_rs, pvt, true);
    title('pvt rs');
end
end



