function [sig_long, sig_short, sig_rs] = Ma(price,lag,flag)
% 价格穿越均线, 返回 sig_long, sig_short, sig_rs
% lag 均线回溯bar数， 默认 10
% flag 均线计算方法， 默认简单平均=0， 其他方法参照 doc ind.ma
% @author Daniel 20130506

% 预处理
if ~exist('lag', 'var'), lag = 10; end
if ~exist('flag', 'var'), flag = 0; end

[ nPeriod, nAsset ] = size(price);
sig_long =  zeros( nPeriod, nAsset );
sig_short = zeros( nPeriod, nAsset );
sig_rs =    zeros( nPeriod, nAsset );

maVal = ind.ma(price, lag, flag);

% 信号步
sig_long(logical(crossOver(price,maVal))) = 1;
sig_short(logical(crossOver(maVal, price))) = -1;
sig_rs( price > maVal ) = 1;
sig_rs( price < maVal ) = -1;


end %EOF