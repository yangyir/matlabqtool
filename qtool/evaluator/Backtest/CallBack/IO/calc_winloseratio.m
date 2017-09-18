%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算策略在起始日和截止日之间，交易输赢次数（两次交易之间）以及平均盈利、平均损失。
% 已经考虑了有交易成本和没有交易成本的两种情况。

% Qichao Pan, 2013/04/23, v1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [winCount,loseCount,totalCount,win_averet,lose_averet,winratio]...
    = calc_winloseratio(tradeList)

% 该函数暂时只针对 [-1，0，1]信号
winIndex = find(tradeList(:,1)>0);
loseIndex = find(tradeList(:,1)<0);
winCount = length(winIndex);
loseCount = length(loseIndex);
totalCount = size(tradeList,1);
win_averet = mean(tradeList(winIndex,1));
lose_averet = mean(tradeList(loseIndex,1));
winratio = winCount/totalCount;
end