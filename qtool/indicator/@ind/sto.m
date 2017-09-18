function [ kVal, dVal] = sto( HighPrice, LowPrice,  ClosePrice, k, d, dm )
% Stochastic oscillator
% default k = 10, d=3, dm ='e'
% daniel 2013/4/16

% 预处理
if ~exist('k','var')
    k = 10;
end

if ~exist('d','var')
    d = 3;
end

if ~exist('dm','var')
    dm = 'e';
end

[nPeriod , nAsset] = size(HighPrice);
kVal = nan(nPeriod, nAsset);
dVal = nan(nPeriod, nAsset);

% 计算步
for i = 1: nAsset
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    closep = ClosePrice(:,i);
    stoVal= stochosc(highp, lowp, closep, k,d,dm);
    kVal(:,i) = stoVal(:,1);
    dVal(:,i) = stoVal(:,2);
end

end
