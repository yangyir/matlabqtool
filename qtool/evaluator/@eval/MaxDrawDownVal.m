function mddVal = MaxDrawDownVal(nav)
% daniel 2013/10/16

nP = size(nav,1);
maxNow = nan(nP,1);

for i = 2:nP
    maxNow(i) = max(nav(1:i));
end

drawdown = maxNow-nav;
mddVal = max(drawdown);
end

