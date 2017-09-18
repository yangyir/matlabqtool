function [ sig_long,sig_short,sig_rs] = Sar( bar, step, maxStep, type)
%% 该函数输出 SAR 的结果以及所对应的交易信号，强弱信号
% sar 强弱信号规则是当 price 在 sar 之上的时候，开多仓；反之则开空仓；
% 输入 high, low, price 分别是每日的最好价，最低价，收盘价；
% 输入 step 为计算 sar 时的增长速度，默认值为 0.02；
% 输入 max  为计算 sar 时的最大偏离步长，默认值为 0.2；
% 输出 sig_long, sig_short 分别为开多仓，开空仓的交易信号；
% 输出 sig_rs 为 sar 指标下的强弱信号，状态为1，-1，0；
% 输出 sar 为计算的数值结果；

%% 数据预处理
high = bar.high;
low = bar.low;
price = bar.close;

if ~exist('step', 'var') || isempty(step), step = 0.02; end
if ~exist('maxStep', 'var') || isempty(maxStep), maxStep = 0.2; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算
[sig_long, sig_short, sig_rs] = tai.Sar(high, low, price, step, maxStep, type);

if nargout == 0
    sar.sar = ind.sar(high, low, step, maxStep, step);
    bar.plotind2(sig_long + sig_short, sar);
    title('sar long and short');
    bar.plotind2(sig_rs, sar);
    title('sar rs');
end

end