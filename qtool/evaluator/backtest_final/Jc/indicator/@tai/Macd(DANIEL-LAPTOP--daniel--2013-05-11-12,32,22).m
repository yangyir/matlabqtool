function [ sig_long, sig_short, sig_rs] = Macd( price, short, long, compare,type)
%% MACD 输出 sig_long, sig_short, sig_rs
% type = 1 (默认）时， barVal>0 开仓， barVal<0 关仓
% type = 2时， barVal, diffVal, daeVal 同为正数开仓，同为负数关仓
% barVal, diffVal, daeVal 含义参照 ind.macd
% 默认参数： short = 12， long = 26， compare = 9， 参照ind.macd;
% @author Daniel 20130506


% 参数预处理

if ~exist('short', 'var') || isempty(short), short = 12; end
if ~exist('long', 'var') || isempty(long), long = 26; end
if ~exist('compare', 'var') || isempty(compare), compare = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end
if short>long
    temp = short;
    short = long;
    long = temp;
    clear temp;
end

[nPeriod, nAsset] = size(price);
sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs = zeros(nPeriod, nAsset);

[diffVal daeVal barVal]=ind.macd(price,long,short,compare);

% 信号步
if type ==1
    zeroline = zeros(nPeriod, nAsset);
    sig_long(logical(crossOver(barVal,zeroline))) = 1;
    sig_short(logical(crossOver(zeroline, barVal))) = -1;
    sig_rs(barVal > zeroline) = 1;
    sig_rs(barVal < zeroline) = -1;
elseif type ==2;
    zeroline = zeros(nPeriod, nAsset);
    sig_long(logical(crossOver(barVal,zeroline)) & logical(crossOver(diffVal,zeroline)) & logical(crossOver(daeVal,zeroline))) = 1;
    sig_short(logical(crossOver(zeroline,barVal)) & logical(crossOver(zeroline,diffVal)) & logical(crossOver(zeroline,daeVal))) = 1;
    sig_rs(barVal>0 & diffVal>0 & daeVal>0)  =  1;
    sig_rs(barVal<0 & diffVal<0 & daeVal<0)  = -1;
else
    ;
end
end %EOF
