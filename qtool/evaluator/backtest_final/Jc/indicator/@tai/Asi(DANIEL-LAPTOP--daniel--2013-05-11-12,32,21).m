function [sig_long, sig_short] = Asi(open, high, low, close, mu_up, mu_down,type)
% ASI 振动升降指标
% 输入：
%【数据】 开盘，最高，最低，收盘
%【参数】 划分前期高低点的mu_up, mu_down
% 输出：sig_long, sig_short, asi
% daniel 2013/4/2

%% 预处理
if ~exist('mu_down', 'var') || isempty(mu_down), mu_down = 0.02; end
if ~exist('mu_up', 'var') || isempty(mu_up), mu_up = 0.02; end
if ~exist('type', 'var') || isempty(type), type = 1; end


sig_long = zeros(size(close));
sig_short = zeros(size(close));

% ASI的計算公式
% 1.  A=當天最高價-前一天收盤價
% 　  B=當天最低價-前一天收盤價
% 　　C=當天最高價-前一天最低價
% 　　D=前一天收盤價-前一天開盤價
% 　　A、B、C、D皆採用絕對值
% 2.  E=當天收盤價-前一天收盤價
% 　　F=當天收盤價-當天開盤價
% 　　G=前一天收盤價-前一天開盤價
% 　　E、F、G採用其+－差值
% 3.  X＝E＋1／2F＋G。
% 4.  K=比較A、B兩數值，選出其中最大值
% 5.  比較A、B、C三數值：
% 　　  若A最大，則R＝A＋ 1／2B＋ 1／4D
% 　　  若B最大，則R＝B＋1／２A十1／4D
% 　　  若C最大，則R= C＋1/4D
% 6.  L＝3
% 7.  SI= 50* X／R * K／L
% 8.  ASI=累計每日之SI值

%% 计算步
[nPeriod, nAsset] = size(open);

[asiVal, siVal] = ind.asi(open, high, low, close);

%% 信号步
% 1.股价和ASI指标同步上升，当ASI领先股价突破前期高点时，是买入信号。
% 2.股价和ASI指标同步下降，当ASI领先股价跌破前期低点时，是卖出信号。
% 3.股价创新高、低，而ASI未创新高、低，代表此高低点不确认。
% 4.股价已突破压力或支撑线，ASI却未伴随发生，为假突破。
% 5.ASI前一次形成的显著高、低点，视为ASI停损点；多头时，ASI跌破前一次低点，停损卖出；空头时，ASI向上突破前一次高点，停损回补。
% 6.股价创新低，而ASI指标未创新低时，为底背离；股价创新高，而ASI指标未同创新高时，为顶背离。

priceHigh = nan(size(close));
priceLow  = nan(size(close));
asiHigh   = nan(size(close));
asiLow    = nan(size(close));

for i= 1: nAsset
    [priceHigh(:,i), priceLow(:,i)] = LastExtrema(close(:,i), mu_up, mu_down);
    [asiHigh(:,i), asiLow(:,i)]     = LastExtrema(asiVal(:,i), mu_up, mu_down);
end

if type==1
sig_long(logical(crossOver(asiVal, asiHigh))) = 1;
sig_short(logical(crossOver(asiLow, asiVal))) = -1;
else
;
end    
end 











