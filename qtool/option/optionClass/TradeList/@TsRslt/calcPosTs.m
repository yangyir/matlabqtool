function [ ] = calcPosTs( obj, TL )
%calcPosTs 将TradeList转换为与一个时间戳对应的仓位时间序列矩阵
% 对齐的过程中，向后对齐。比如9：20的交易，9：00没有仓位，10：00有仓位。
% 按照这种对齐方式，如果是时间戳是整天的，则需要向前对齐，因为此时的时间是不连续的。
% 并且默认一天包括了这天的开始和结束，即它是一个时间段；而一般的时间戳默认的是代表
% 一个时间点。

% 潘其超，20140701，V1.0
% 潘其超，20140730，V2.0
%   1. 加入了对空TradeList的处理。

%%
if TL.latest == 0
    return;
end

% 将tradeList中的空白部分剪掉，方便后面代码编写
TL.prune();

% 时间戳的长度应该包含TradeList里面的时间跨度
if TL.time(1)<obj.time(1)
    disp('时间戳晚于第一笔交易！');
    return;
end

if TL.time(end)>obj.time(end)
    disp('时间戳早于最后一笔交易！');
    return;
end

%%
% 合约类型
numInstr = length(obj.instrType);
numTime = length(obj.time);
numItem = length(TL.time);

% 先计算差分矩阵
deltaPos = zeros(numTime,numInstr);


% findTimeIdx 是最耗时的一步，并且使用了两次，单列
% 采用了优化算法，但是TL必须是sorted
instrIdxVec = zeros(numItem,1);
for i = 1:numItem
    instrIdxVec(i) = find(obj.instrType==TL.instrumentNo(i));
    TL.tick(i) = find(obj.time>=TL.time(i),1,'first');
end

% 逐条查询
for i = 1:numItem
    timeIdxCurr = TL.tick(i);
    instrIdxCurr = instrIdxVec(i);
    % 有可能在一个时间刻度下，发生多笔交易
    deltaPos(timeIdxCurr,instrIdxCurr) = deltaPos(timeIdxCurr,instrIdxCurr)+TL.volume(i)*TL.direction(i);
end

% 累计出仓位
obj.posArr = cumsum(deltaPos);

% 计算峰值仓位
currPos = [zeros(size(obj.instrType));obj.posArr(1:end-1,:)];
obj.maxPosArr = currPos;
for i = 1:numItem
    timeIdxCurr = TL.tick(i);
    instrIdxCurr = instrIdxVec(i);
    currPos(timeIdxCurr,instrIdxCurr) = currPos(timeIdxCurr,instrIdxCurr)+TL.volume(i)*TL.direction(i);
    
    if abs(currPos(timeIdxCurr,instrIdxCurr))>abs(obj.maxPosArr(timeIdxCurr,instrIdxCurr))
        obj.maxPosArr(timeIdxCurr,instrIdxCurr) = currPos(timeIdxCurr,instrIdxCurr);
    end
end





end

