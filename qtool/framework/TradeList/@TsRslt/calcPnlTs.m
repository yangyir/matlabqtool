function [  ] = calcPnlTs( obj, TL, price )
%CACLPNLTS 计算资金相关的时间序列
% price 是与时间×合约对应

% 潘其超，20140701，V1.0
% 潘其超，20140730，V2.0
%   1. 加入了对空TradeList的处理。

%%
if TL.latest ==0
    return;
end
% 合约类型
numInstr = length(obj.instrType);
numTime = length(obj.time);
numItem = length(TL.time);

% 先计算佣金和交易的差分矩阵
commission = zeros(numTime,numInstr);
tradePnl = zeros(numTime,numInstr);

% 逐条查询
for i = 1:numItem
    instrIdx = obj.instrType==TL.instrumentNo(i);
    timeIdx = TL.tick(i);
    % 有可能在一个时间刻度下，发生多笔交易
    if TL.tradeID(i)>0
        commission(timeIdx,instrIdx) = commission(timeIdx,instrIdx) +...
            TL.volume(i)*TL.price(i)*obj.multiplier(instrIdx)*obj.cmsnRate(instrIdx);
    end
    
    tradePnl(timeIdx,instrIdx) = tradePnl(timeIdx,instrIdx) + ...
        TL.volume(i)*(price(timeIdx,instrIdx)-TL.price(i))*TL.direction(i)*obj.multiplier(instrIdx);
end

% 持仓盈亏
holdPnl = obj.posArr(1:end-1,:).*diff(price);
holdPnl = bsxfun(@times,holdPnl,obj.multiplier);
holdPnl = [zeros(size(obj.instrType));holdPnl];

obj.cumCmsnArr = cumsum(commission);
obj.cumPnlArr = cumsum(holdPnl+tradePnl)-obj.cumCmsnArr;

% 冻结资金，是个不精确的值，按照时间端内的最高仓位×时间段的收盘价计算
obj.frozenMarginArr = abs(obj.maxPosArr).*price;
obj.frozenMarginArr = bsxfun(@times,obj.frozenMarginArr,obj.multiplier.*obj.marginRate);

% 矩阵2向量
obj.cumPnlVec = sum(obj.cumPnlArr,2);
obj.cumCmsnVec = sum(obj.cumCmsnArr,2);
obj.frozenMarginVec = sum(obj.frozenMarginArr,2);

% 反推初始资金
if obj.initNav ==0
    obj.initNav = max(obj.frozenMarginVec)*2;
end

% 计算风险收益
obj.calcRNR();

end

