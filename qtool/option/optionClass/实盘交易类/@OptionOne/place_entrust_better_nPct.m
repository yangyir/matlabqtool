function [e] = place_entrust_better_nPct(obj, direc, volume,  nPct, offset)
% 下单可以设置价格让步的百分比
% [e] = place_entrust_better_nPct(obj, direc, volume, offset, nPct)
% nPct 可取（0,100%）以外
% ask 到 bid 作为100%， 即
%　买: bid 0%, ...,  ask 100%, ...
%  卖：ask 0%, ...,  bid 100%, ...
% ---------------------
% cg， 20160405

quote = obj.quote;

if ~exist('nTick', 'var')
    nPct = 0.50;
end

% TODO: autoOffset
if ~exist('offset', 'var')
    offset = 1;  % 开仓
end


%% main
a = quote.askP1;
b = quote.bidP1;
abs = a - b;

switch direc
    case{'1', 1, 'b', 'buy'}
        px = b + nPct * abs;
    case{'2', -1, 's', 'sell'}
        px  = a - nPct * abs;
end

e = obj.place_entrust_opt(direc, volume, offset, px);

end