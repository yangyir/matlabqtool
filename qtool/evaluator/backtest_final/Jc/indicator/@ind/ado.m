function [ adoVal ] = ado( HighPrice, LowPrice, OpenPrice, ClosePrice )
% Accumulation/Distribution oscillator
% daniel 2013/4/16

% 预处理
[nPeriod , nAsset] = size(HighPrice);
adoVal = nan(nPeriod, nAsset);

% 计算步
for i = 1: nAsset
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    openp = OpenPrice(:,i);
    closep = ClosePrice(:,i);
    adoVal(:,i) = adosc(highp, lowp, openp, closep);
end

end

