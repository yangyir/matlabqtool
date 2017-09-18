function [sig_rs] = Tsi (close, fast, slow,type)
% TSI 真实强弱指数
% daniel 2013/3/21
% luhuaibao, 2013/09/02,  修改16行为17行

if ~exist('slow', 'var') || isempty(slow), slow = 25; end
if ~exist('fast', 'var') || isempty(fast), fast = 13; end
if ~exist('type', 'var') || isempty(type), type = 1; end
[nPeriod, nAsset] = size(close);


[tsiVal] = ind.tsi (close, fast, slow);
sig_rs = zeros(nPeriod, nAsset);
if type==1
sig_rs (tsiVal>25) = -1;
% sig_rs (tsiVal<25) = 1;
sig_rs (tsiVal<-25) = 1;
else
;
end