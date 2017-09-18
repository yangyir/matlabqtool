function [atrVal] = atr( HighPrice, LowPrice, ClosePrice, nDay)
% average true range
% 默认回溯天数 nDay =14
% daniel 2013/4/16

% 预处理
if ~exist('nDay','var'),  nDay = 14; end
[nPeriod, nAsset] = size(HighPrice);
atrVal = nan(nPeriod, nAsset);

% 计算步
hml = HighPrice-LowPrice;
hmc = [zeros(1,nAsset); abs(HighPrice(2:nPeriod,:)-ClosePrice(1:nPeriod-1,:))]; % abs(high - close)
lmc = [zeros(1,nAsset); abs(LowPrice(2:nPeriod,:)-ClosePrice(1:nPeriod-1,:))];  % abs(low - close)
tr  = max(max(hml,hmc),lmc);
tr(isnan(tr)) = 0;
atrVal(nDay,:) = mean(tr(1:nDay,:));

for iPeriod = nDay +1 : nPeriod
    atrVal(iPeriod, :) = atrVal(iPeriod -1,:)*(nDay-1)/nDay + tr(iPeriod,:)/nDay;
end
end




