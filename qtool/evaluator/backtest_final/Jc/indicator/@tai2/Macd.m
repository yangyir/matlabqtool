function [ sig_long, sig_short, sig_rs ] = Macd( bar, short, long, compare, type)
% 该函数输出多只股票的MACD值，以及基于MACD的交易信号和强弱信号
% macd的信号判定规则为当macd的三个输出都是正数时，sig_rs = 1；都是负数时，sig_rs = -1；
% 输入 price 为每日收盘价的时间序列；
% 输入 short 为短期移动平均的天数，默认为 12；
% 输入 long  为长期移动平均的天数，默认为 26；
% 输入compare为差值的移动平均天数，默认为  9；
% 输出 sig_long 为做多的交易信号；
% 输出 sig_short为做空的交易信号；
% 输出 sig_rs为强弱信号，表示该天macd指标给出的买卖状态；
% 输出 macd 为 struct 类型，其中包含了 macd 指标的三个输出结果；
% macd 属于趋势信号，因此给出开平仓交易信号；

% 参数预处理
if ~exist('short', 'var') || isempty(short), short = 12; end
if ~exist('long', 'var') || isempty(long), long = 26; end
if ~exist('compare', 'var') || isempty(compare), compare = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end
price = bar.close;

% 计算
[sig_long, sig_short, sig_rs] = tai.Macd(price, short, long, compare, type);

if nargout == 0
    [macd.diff, macd.dae, macd.bar] = ind.macd(price, short, long, compare);
    bar.plotind2(sig_long + sig_short, macd, true);
    title('macd long and short');
    bar.plotind2(sig_rs, macd, true);
    title('macd rs');
end

end
