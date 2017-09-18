function [pvtVal] = pvt(ClosePrice,Volume)
% Price Volume Trend 价量趋势指标
% daniel 2013/4/16

% 预处理
[nPeriod, nAsset] = size(ClosePrice);
pvtVal = zeros(nPeriod, nAsset);

% 计算步
% 如果设x＝(今日收盘价—昨日收盘价)／昨日收盘价×当日成交量，
% 那么当日PVT指标值则为从第一个交易日起每日X值的累加。
pvtVal = [nan(1,nAsset); (ClosePrice(2:end,:)./ClosePrice(1:end-1,:)-1)].*Volume;
pvtVal(isnan(pvtVal)) = 0 ;
pvtVal = cumsum(pvtVal);

end %EOF



