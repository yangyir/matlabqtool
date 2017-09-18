function  [diffVal, daeVal, barVal]=macd(price, long, short,compare)

%%

if ~exist('long', 'var') || isempty(long), long = 26; end
if ~exist('short', 'var') || isempty(short), short = 12; end
if ~exist('compare', 'var') || isempty(compare), compare = 9; end
%%
% ������ںͳ���ָ��ƽ��
ema_short = ind.ma(price,short,'e');
ema_long  = ind.ma(price,long,'e');

%%
% ���� macd ���������
diffVal  =  ema_short-ema_long;
daeVal   =  ind.ma(diffVal,compare,'e');
barVal  =   diffVal - daeVal;