function [ sig_long, sig_short, sig_rs] = Dmi( bar, lag, thred, type)
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

if ~exist('lag', 'var') || isempty(lag), lag = 14; end
if ~exist('thred', 'var') || isempty(thred), thred = 18; end
if ~exist('type', 'var') || isempty(type), type = 1; end

highPrice = bar.high;
lowPrice = bar.low;
closePrice = bar.close;

% 计算
[sig_long, sig_short, sig_rs] = tai.Dmi(highPrice, lowPrice, closePrice, lag, thred, type);

if nargout == 0
    [dmi.dmiup, dmi.dmidown, dmi.adx] = ind.dmi(highPrice, lowPrice, closePrice, lag);
    bar.plotind2(sig_long + sig_short, dmi, true);
    title('dmi long and short');
    bar.plotind2(sig_rs, dmi, true);
    title('dmi rs');
end

end