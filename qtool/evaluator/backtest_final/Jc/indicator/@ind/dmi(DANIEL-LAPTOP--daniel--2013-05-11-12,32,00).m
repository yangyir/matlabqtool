function [dmiup, dmidown, adx ]=dmi(highPrice, lowPrice, closePrice, lag)

%DMI 计算DMI(动向指数）并给出信号
%   输入：
%    highPrice 最高价格
%    lowPrice 最低价格
%    closePrice 收盘价格
%    lag 延时（默认14）
%    thred ADX牛皮市阀值
%   输出：
%    sig 买卖信号
%    dmi.diup +DI，
%    dmi.didown -DI
%    dmi.dx DX指数
%    dmi.adx ADX指数（DX经过EMA后得到）

%%
if ~exist('lag', 'var') || isempty(lag), lag = 14; end
[nPeriod, nAsset] = size(highPrice);

%%
dmup = nan(nPeriod, nAsset);
dmdown = nan(nPeriod, nAsset);
dmup(2:nPeriod, :) = highPrice(2:end,:) - highPrice(1:end-1,:);
dmdown(2:nPeriod, :) = -(lowPrice(2:end,:) - lowPrice(1:end-1,:));
dmup(dmup<0) = 0;
dmdown(dmdown<0) = 0;
dmup(dmup < dmdown) = 0;
dmdown (dmdown < dmup) = 0;

%% 计算TR
tr = nan(nPeriod, nAsset);
tr(2:nPeriod, :) = max(abs(highPrice(2:end, :)-lowPrice(2:end, :)),abs(closePrice(1:end-1, :)-highPrice(2:end,:)));
tr(2:nPeriod, :) = max(tr(2:nPeriod, :), abs(closePrice(1:end-1, :) - lowPrice(2:end, :)));
trm = tai.Ma(tr, lag, 0);

dmiup = tai.Ma(dmup, lag, 0)./trm * 100;
dmidown = tai.Ma(dmdown, lag, 0)./trm * 100;

dx = abs(( dmiup - dmidown )./( dmiup + dmidown )) * 100;
adx = tai.Ma( dx, lag, 'e');

