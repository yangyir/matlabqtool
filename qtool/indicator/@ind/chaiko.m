function [ choVal] = chaiko( HighPrice, LowPrice,  ClosePrice, Volume )
% Chaikin oscillator
% daniel 2013/4/16

% 预处理
[nPeriod , nAsset] = size(HighPrice);
choVal = nan(nPeriod, nAsset);

% 计算步
for i = 1: nAsset
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
    volume = Volume(:,i);
    choVal(:,i) = chaikosc(highp, lowp, closep, volume);
end

end
