function [mddVal, idx] = maxDrawDownVal(nav)
% ��������س�
% [mddVal, idx] = maxDrawDownVal(nav)
% ---------------------
% daniel 2013/10/16
% �̸գ�20150510��С�ģ�����idx


%% main

maxNow      = evl.preHigh(nav);
drawdown    = maxNow - nav;
[mddVal,idx]= max(drawdown);
end

