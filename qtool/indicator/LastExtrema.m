function [extremaHigh, extremaLow, currentStat] = LastExtrema(data, mu_up, mu_down)
% 输出最近的高点，低点,以及当前在下降还是上升（相比最近的极值点）
% 调用trendAnalysis
% 相比hhigh 和 llow函数，lastExtrema不限定过去步长,但是使用斜率来判断极值点

%% 预处理
[stat, lastSure] = trendAnalysis( data, mu_up, mu_down );

nPeriod = size(stat,1);
extremaHigh = nan(nPeriod, 1);
extremaLow  = nan(nPeriod, 1);
currentStat = zeros(nPeriod,1);

%% 计算步
idxExtrema = unique(lastSure);
valExtrema = nan(size(idxExtrema));
valExtrema(1) = nan;
valExtrema(2:end) = data(idxExtrema(2:end));

for i = 2 : size(idxExtrema,1)
    if stat(idxExtrema(i)) == 1 % 如果最近的是局部高点
        valHigh = valExtrema(i);
        valLow  = valExtrema(i-1);
        currentStat(lastSure == idxExtrema(i)) = 1;
    else                        % 否则最近的是局部低点
        valHigh = valExtrema(i-1);
        valLow  = valExtrema(i);
        currentStat(lastSure == idxExtrema(i)) = -1;
    end
    extremaHigh(lastSure == idxExtrema(i)) = valHigh;
    extremaLow(lastSure  == idxExtrema(i)) = valLow;
end

end %EOF

    
    







