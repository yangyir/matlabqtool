function [ preHi, idx ] = preHigh( nav )
%PREHIGH 计算nav序列的前高值，结果是单调增序列
% ----------------------------------
% 程刚，20150510

%% main
nP      = size(nav,1);
preHi   = nan(nP,1);
idx     = nan(nP,1);

for i = 1:nP
    [preHi(i),idx(i)] = max(nav(1:i));
end


end

