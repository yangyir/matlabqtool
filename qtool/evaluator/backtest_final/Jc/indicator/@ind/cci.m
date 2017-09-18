function [ cciVal] = cci( HighPrice, LowPrice, ClosePrice,nDay,mdDay,const )
% commodity channel index
% default nDay = 20, mDay =20, const = 0.015
% daniel 2013/4/16

% 预处理
if ~exist('nDay','var'), nDay = 20; end
if ~exist('mdDay','var'), mdDay = 20; end
if ~exist('const','var'), const=0.015; end
[nPeriod, nAsset] = size(ClosePrice);

% 计算步
% CCI = (Typical Price  -  20-period SMA of TP) / (.015 x Mean Deviation)
% Typical Price (TP) = (High + Low + Close)/3
% Constant = .015
TypicalPrice = (HighPrice+LowPrice+ClosePrice)/3;
TP_MA   = ind.ma(TypicalPrice, nDay, 0);
MeanDev = nan(nPeriod, nAsset);

for i = mdDay:nPeriod
    MeanDev(i,:) = mean(abs(TP_MA(i,:)-TypicalPrice(i-mdDay+1:i,:)));
end

cciVal = (TypicalPrice - TP_MA)./(const*MeanDev);

end %EOF