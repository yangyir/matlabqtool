function [sig_rs] = Tsi (bar, fast, slow, type)
% TSI 真实强弱指数

if ~exist('slow', 'var') || isempty(slow), slow = 25; end
if ~exist('fast', 'var') || isempty(fast), fast = 13; end
if ~exist('type', 'var') || isempty(type), type = 1; end
close = bar.close;

sig_rs = tai.Tsi(close, fast, slow, type);

if nargout == 0
    tsi.tsi = ind.tsi(close, fast, slow);
    bar.plotind2(sig_rs, tsi, true);
    title('sig rs');
end
end