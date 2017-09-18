function  [ mfiVal, pmf, nmf ] = mfi(HighPrice, LowPrice, ClosePrice, Volume, nDay )
% money flow index 资金流量指标
% default nDay  = 14
% 2013/3/21 daniel

% 预处理
if ~exist('nDay','var')
    nDay = 14;
end
[nPeriod, nAsset] = size(ClosePrice);
upordown = ones(nPeriod, nAsset);
rmf = nan(nPeriod, nAsset);
pmf = zeros(nPeriod,nAsset);
nmf = zeros(nPeriod, nAsset);
mfiVal = zeros(nPeriod, nAsset);

% 计算步
% 1.典型价格（TP）=当日最高价、最低价与收盘价的算术平均值
% 2.货币流量（MF）=典型价格（TP）×N日内成交金额
% 3.如果当日MF>昨日MF，则将当日的MF值视为正货币流量（PMF）
% 4.如果当日MF<昨日MF，则将当日的MF值视为负货币流量（NMF）
% 5.MFI=100-[100/(1+PMF/NMF)]
% 6.参数N一般设为14日。

tp = (HighPrice + LowPrice + ClosePrice)/3;  %typical price
upordown(tp(2:nPeriod,:)<=tp(1:nPeriod-1,:))=-1; % up or down
rmf(2:nPeriod,:) =  tp(2:nPeriod,:).* Volume(2:nPeriod,:); % raw money flow

pmf(upordown == 1) = rmf(upordown==1);  % positive money Flow
nmf(upordown ==-1) = rmf(upordown==-1); % negative money flow

for iPeriod = nDay:nPeriod
    mfiVal(iPeriod,:) = sum(pmf(iPeriod-nDay+1:iPeriod,:))./sum(nmf(iPeriod-nDay+1:iPeriod,:));
end
mfiVal= 100- 100./(1+mfiVal);

end %EOF


