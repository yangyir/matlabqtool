function [sig_long,sig_short, sig_rs] = Bbi(bar, lag1, lag2, lag3, lag4, type)
% bbi 多空指数
% 输入
% 【数据】 收盘价
% 【参数】 4个n日均价
% 输出
% 【多头】 sig_long: 价格突破bbi
% 【空头】 sig_short： 价格跌破bbi
% 【强弱】 sig_rs： 价格在bbi上方为强势，价格在bbi下方为弱势
% 2013/3/21 daniel

% 计算公式
% ＢＢＩ＝(３日均价＋６日均价＋１２日均价＋２４日均价)÷４从多空指数的计算公式可以看出，多空指数的数值分别包含了不同日数移动平均线的部分权值，这是一种将不同日数的移动平均值再平均的数值，从而分别代表了各条平均线的“利益”。事实上，多空指数是移动平均原理的特殊产物，起到了多空分水岭的作用。
% 应用法则
% 法则一
% 1. 股价位于BBI 上方，视为多头市场。
% 2. 股价位于BBI 下方，视为空头市场。
% 法则二
% １、股价在高价区以收市价向下跌破多空线为卖出信号。
% ２、股价在低价区以收市价向上突破多空线为买入信号。
% ３、多空指数由下向上递增，股价在多空线上方，表明多头势强，可以继续持股。
% ４、多空指数由上向下递减，股价在多空线下方，表明空头势强，一般不宜买入。

%% 数据预处理
close = bar.close;
if ~exist('lag4', 'var') || isempty(lag4), lag4 = 24; end
if ~exist('lag3', 'var') || isempty(lag3), lag3 = 12; end
if ~exist('lag2', 'var') || isempty(lag2), lag2 = 6; end
if ~exist('lag1', 'var') || isempty(lag1), lag1 = 3; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算步
[sig_long, sig_short, sig_rs] = tai.Bbi(close, lag1, lag2, lag3, lag4, type);

%% 信号输出
if nargout == 0
    bbi.bbi = ind.bbi(close, lag1, lag2, lag3, lag4);
    bar.plotind2(sig_long + sig_short, bbi);
    title('Bbi long and short');
    bar.plotind2(sig_rs, bbi);
    title('Bbi rs');
end

end %EOF