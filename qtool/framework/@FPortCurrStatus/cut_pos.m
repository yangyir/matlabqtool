function [position, avgCost, commission ] = cut_pos(obj, spotPrice, posCut)
%% Reduce open interests by selling or buying to cover posCut contracts at spotPrice.
% Return position avgCost and commission after operation.
%%
% check current unit
if obj.currUnit<=0
    error('Cannot cut position!');
end

totPos = sum(obj.enterPos);
absTotPos = abs(totPos);
if posCut>=absTotPos
    [position, avgCost, commission] = obj.close_pos(spotPrice);
elseif posCut<=0
    error('number of position cut should be positive.');
else
    if obj.currUnit>0
        direction = 1;
    else
        direction = -1;
    end
    currCumPos = abs(cumsum(obj.enterPos));
    index = find(currCumPos>posCut,1,'first');
    absUnit = abs(obj.currUnit);
    if index == 1
        obj.enterPos(1) = obj.enterPos(1)-posCut*direction;    
    else
        obj.currUnit = (absUnit-index+1)*direction;
        obj.enterPrice = [obj.enterPrice(index:absUnit),zeros(1,index-1)];
        obj.stopLoss = [obj.stopLoss(index:absUnit),zeros(1,index-1)];
        obj.enterPos(index) = (currCumPos(index)-posCut)*direction;
        obj.enterPos(index) = [obj.enterPos(index:absUnit),zeros(1,index-1)];    
    end
    
    if ~obj.virtualOn
        position = sum(obj.enterPos);
        avgCost = sum(obj.enterPrice.*obj.enterPos)/position;
        commission = spotPrice*posCut*obj.multiplier*obj.commissionRate;
    else
        position = 0;
        avgCost = 0;
        commission = 0;
    end
end

end

