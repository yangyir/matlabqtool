function displa = displacement( bars , window )
% 计算一段窗口期的位移
% 输入:
% bars 数据；
% window 窗口期的长度；
% 输出：
% displa 位移的时间序列。

% by wuzehui, version v1.0, 2013/6/25
% by wuzehui, version v1.1, 2013/7/21

%
nperiod = length(bars.open);
displa = nan(nperiod,1);
displa(window:end) = bars.close( window:end ) - bars.open( 1:end-window+1 );

end % End of file