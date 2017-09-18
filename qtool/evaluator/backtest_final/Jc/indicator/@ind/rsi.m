function [ rsiVal, rsVal] = rsi( ClosePrice, nDay)
% Relative Strength Index 相对强弱指数
% 返回rsi和rs的数值（[nPeriod, nAsset] 矩阵）
% default nDay =14
% daniel 2013/4/16

% 预处理
if ~exist('nDay','var')
    nDay = 14;
end
[nPeriod, nAsset] = size(ClosePrice);
rsiVal = nan(nPeriod, nAsset);
rsVal  = nan(nPeriod, nAsset);

% 计算步
% RSI = 100 - 100/(1 + RS)
% Where RS = Average of x days' up closes / Average of x days' down closes.
diffClose = [nan(1,nAsset);  diff(ClosePrice)];
diffChg   = abs(diffClose);
advances = diffChg;
declines = diffChg;
advances(diffClose < 0 ) = 0;
declines(diffClose > 0 ) = 0;

for iAsset = 1 : nAsset
    for jPeriod = nDay : nPeriod
        totalGain = sum(advances(jPeriod - nDay+1:jPeriod,:));
        totalLoss = sum(declines(jPeriod - nDay+1:jPeriod,:));
        rsVal(jPeriod,:) = totalGain./totalLoss;
        rsiVal(jPeriod,:) = 100 - (100./(1+rsVal(jPeriod,:)));
    end
end      

end

