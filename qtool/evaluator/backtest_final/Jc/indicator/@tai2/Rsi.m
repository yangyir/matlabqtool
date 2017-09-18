function [sig_long, sig_short, sig_rs ] = Rsi(bar, long, short,type)
%% 函数输出 RSI 及其决定的强弱信号;
% rsi 为量能指标，因此只输出强弱信号；
% 输入 price 为每日收盘价；
% 输入 long，short 用来计算不同周期下的 rsi
% 输出为强弱信号 sig_rs 以及 rsi

%% 变量预处理以及初始化
if ~exist('long', 'var') || isempty(long), long = 14; end
if ~exist('short', 'var') || isempty(short), short = 7; end
if ~exist('type', 'var') || isempty(type), type=1; end
price = bar.close;

%% 指标
[sig_long, sig_short, sig_rs] = tai.Rsi(price, long, short, type);


if nargout == 0
    rsi.long = ind.rsi(price, long);
    rsi.short = ind.rsi(price, short);
    bar.plotind2(sig_rs, rsi, true);
    title('rsi rs');
end
end