function [ adlVal ] = adl( HighPrice, LowPrice, ClosePrice, Volume )
% Accumulation/Distribution line
% daniel 2013/4/17

% 预处理
[nPeriod , nAsset] = size(HighPrice);
adlVal = nan(nPeriod, nAsset);

% 计算步
for i = 1: nAsset
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
    volume = Volume(:,i);
    adlVal(:,i) = adosc(highp, lowp, closep, volume);
end


end

