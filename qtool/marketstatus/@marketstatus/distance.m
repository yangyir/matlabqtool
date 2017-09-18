function dist = distance( bars, window)
% 计算一段窗口期内的距离
% 输入：
% bars：交易数据；
% window：窗口期的bar数；
% 输出：
% dist：距离的时间序列.
% version:v1.0 Wu Zehui 2013/6/25
% version:v1.1 Wu Zehui 2013/7/21

% 预处理
nperiod = length(bars.open);
if nperiod < window
    error('window input error.');
else
    dist = nan(nperiod,1);
    % 计算
    absdist = abs(bars.close-bars.open);
    for iperiod = window:nperiod
        dist(iperiod) = sum(absdist(iperiod-window+1:iperiod));
    end
end
end % End of file