function [mddVal, idx] = maxDrawDownVal(nav)
% 最大连续回撤
% [mddVal, idx] = maxDrawDownVal(nav)
% ---------------------
% daniel 2013/10/16
% 程刚，20150510，小改，加入idx


%% main

maxNow      = evl.preHigh(nav);
drawdown    = maxNow - nav;
[mddVal,idx]= max(drawdown);
end

