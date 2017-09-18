function  [diffVal, daeVal, barVal]=macd(price, long, short,compare)

%%

if ~exist('long', 'var') || isempty(long), long = 26; end
if ~exist('short', 'var') || isempty(short), short = 12; end
if ~exist('compare', 'var') || isempty(compare), compare = 9; end
%%
% 计算短期和长期指数平滑
ema_short = ind.ma(price,short,'e');
ema_long  = ind.ma(price,long,'e');

%%
% 计算 macd 的三个输出
diffVal  =  ema_short-ema_long;
daeVal   =  ind.ma(diffVal,compare,'e');
barVal  =   diffVal - daeVal;