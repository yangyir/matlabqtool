function [ rsiVal, rsVal] = rsi_v2( ClosePrice, nDay, mode)
% Relative Strength Index 相对强弱指数
% 返回rsi和rs的数值（[nPeriod, nAsset] 矩阵）
% default nDay =14
% daniel 2013/4/16

%%20130815 修改版本 加入了计算RSI时，使用均线计算方法的选择
% mode：  MA计算方法
%         e = 指数移动平均
%         0 = 简单移动平均
%         0.5 = 平方根加权平均
%         1 = 线性平均
%         2 = 平方加权平均

% 预处理
if ~exist('nDay','var')
    nDay = 14;
end
[nPeriod, nAsset] = size(ClosePrice);
rsiVal = nan(nPeriod, nAsset);
rsVal  = nan(nPeriod, nAsset);

if nargin<3 || isempty(mode)
    mode = '0';
end

% 计算步
% RSI = 100 - 100/(1 + RS)
% Where RS = Average of x days' up closes / Average of x days' down closes.
diffClose = [nan(1,nAsset);  diff(ClosePrice)];
diffChg   = abs(diffClose);
advances = diffChg;
declines = diffChg;
advances(diffClose < 0 ) = 0;
declines(diffClose > 0 ) = 0;

[maadv] = ind.ma(advances,nDay,mode);
[madec] = ind.ma(declines,nDay,mode);

for iAsset = 1 : nAsset
    for jPeriod = nDay : nPeriod
        totalGain = maadv(jPeriod);
        totalLoss = madec(jPeriod);
        rsVal(jPeriod,:) = totalGain./totalLoss;
        rsiVal(jPeriod,:) = 100 - (100./(1+rsVal(jPeriod,:)));
    end
end      

end

