%% 取数据
load('Y:\qdata\IF\intraday_bars_300s_daily\IF0Y00_20130306.mat');
b = IF0Y00_20130306

%% 画出K线图
b.plot;

%% 算衍生数据
% 先在workspace里看一眼b，应该没有衍生数据
% 执行autocalc后，就有衍生数据了
b = b.autocalc

%% 标示指定位置

% 生成showplace序列
len = length(b.close);
showplace = rands(len);

% 只会标示序列中的 >0 的位置，其它数字不管
b.plotind( showplace )
