function [] = pairSI(obj,SIInfo)
% 潘其超，20140703，V1.0

% 潘其超，20140811，V2.0
%   1. 对于不加roundNo的，直接做翻仓处理。

posQueue = java.util.ArrayDeque;

% 第一笔交易做底仓
posQueue.add(SIInfo(1,:));
currDrctn = SIInfo(1,obj.directionI);
for i = 2:size(SIInfo,1)
    newTrade = SIInfo(i,:);
    if newTrade(obj.directionI)== currDrctn
        % 开仓
        posQueue.add(newTrade);
    else
        % 平仓
        while(newTrade(obj.volumeI)>0)
            firstPos  = posQueue.peek();
            if isempty(firstPos)
                posQueue.add(newTrade);
                currDrctn = -currDrctn;
                break;
                % error('Pair Trade Error!');
            end
            
            obj.rcdNum = obj.rcdNum+2;
            if firstPos(obj.volumeI)<=newTrade(obj.volumeI)
                % 平仓数量大于等于第一个可平仓位
                % 开仓交易
                obj.data(obj.rcdNum-1,1:obj.TLIdx) = firstPos;
                % 平仓交易
                obj.data(obj.rcdNum,1:obj.TLIdx) = newTrade;
                % 修正平仓数量
                obj.data(obj.rcdNum,obj.volumeI) = firstPos(obj.volumeI);
                % 修正平仓数量
                newTrade(obj.volumeI) = newTrade(obj.volumeI) - firstPos(obj.volumeI);
                % 去掉已平仓位
                posQueue.poll();
                if posQueue.isEmpty()&&newTrade(obj.volumeI)>0
                    % 翻仓点
                    newTrade(obj.offSetFlagI) =1;
                    % added QP,20150108
                    posQueue.add(newTrade);
                    currDrctn = -currDrctn;
                    break;
                end
            else
                % 平仓数量小于等于第一个可平仓位
                % 开仓交易
                obj.data(obj.rcdNum-1,1:obj.TLIdx) = firstPos;
                % 平仓交易
                obj.data(obj.rcdNum,1:obj.TLIdx) = newTrade;
                % 修正平仓数量
                obj.data(obj.rcdNum-1,obj.volumeI) = newTrade(obj.volumeI);
                % 修正平仓数量
                firstPos(obj.volumeI) = firstPos(obj.volumeI) - newTrade(obj.volumeI);
                % 修改持仓队列中剩余数量
                posQueue.poll();
                posQueue.addFirst(firstPos);
                
                newTrade(obj.volumeI)=0;
            end
            
        end
    end
end % for items

while ~posQueue.isEmpty()
    holdPos = posQueue.poll();
    stlmtPos = nan(size(holdPos));
    stlmtPos(obj.directionI) =  -holdPos(obj.directionI);
    stlmtPos(obj.volumeI) = holdPos(obj.volumeI);
    stlmtPos(obj.strategyNoI) = holdPos(obj.strategyNoI);
    stlmtPos(obj.instrumentNoI) = holdPos(obj.instrumentNoI);
    stlmtPos(obj.roundNoI) = holdPos(obj.roundNoI);

    obj.rcdNum = obj.rcdNum+2;
    % 开仓交易
    obj.data(obj.rcdNum-1,1:obj.TLIdx) = holdPos;
    % 虚拟平仓交易
    obj.data(obj.rcdNum,1:obj.TLIdx) = stlmtPos;  
end

end % pairSI

