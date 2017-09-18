function [ sig_long, sig_short, sig_rs ] = Aroon(bar, nDay, upband, lowband, type)
% 计算Aroon指标及信号
% 输入：
% 【数据】 最高价，最低价
% 【参数】 nDay回顾天数， upband 上界（默认70）， downband下界（默认30）
% 输出： 
% 【多头信号】sig_long ： 当aroon.up穿过aroon.down时买入，无平仓条件。
% 【空头信号】sig_short： 当aroon.down穿过aroon.up时卖空，无平仓条件。
% 【强弱】sig_rs：当aroon.up在upband（70)以上并且aroon.down在lowband（30）以下，为强势上升市场
% 当aroon.up在upband（30)以下并且aroon.down在lowband（70）以上，为弱势下降市场

% The word aroon is Sanskrit for "dawn’s early light". The Aroon indicator
% attempts to show when a new trend is dawning. The indicator consists of
% two lines (Up and Down) that measure how long it has been since the
% highest high/lowest low has occurred within an n period range.
% 
% When the Aroon Up is staying between 70 and 100 then it indicates an
% upward trend. When the Aroon Down is staying between 70 and 100 then it
% indicates an downward trend. A strong upward trend is indicated when the
% Aroon Up is above 70 while the Aroon Down is below 30. Likewise, a strong
% downward trend is indicated when the Aroon Down is above 70 while the
% Aroon Up is below 30. Also look for crossovers. When the Aroon Down
% crosses above the Aroon Up, it indicates a weakening of the upward trend
% (and vice versa).
% 
% The Aroon indicator was developed by Tushar S. Chande and first described
% in the September 1995 issue of Technical Analysis of Stocks & Commodities
% magazine.

%% 1. 预处理
if ~exist('lowband', 'var') || isempty(lowband), lowband = 30; end
if ~exist('upband', 'var') || isempty(upband), upband = 70; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 25; end
if ~exist('type', 'var') || isempty(type), type = 1; end

high = bar.high;
low = bar.low;

[sig_long, sig_short, sig_rs] = tai.Aroon(high, low, nDay, upband, lowband, type);

if nargout == 0
    [aroon.up, aroon.down] = ind.aroon(high, low, nDay);
    bar.plotind2(sig_long + sig_short, aroon, true);
    title('Aroon long and short');
    bar.plotind2(sig_rs, aroon, true);
    title('Aroon rs');
end