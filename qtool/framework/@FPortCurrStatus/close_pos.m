function [ position, avgCost,commission] = close_pos( obj, closePrice)
%%
% Close all positions at spotPrice, set current total positions and
% average cost to zeros, and return operation commission.
%%
% calculate avgCost.
absUnit = abs(obj.currUnit);
if absUnit>0 && absUnit<=obj.maxUnit
    position = sum(obj.enterPos);
    avgCost = sum(obj.enterPrice.*obj.enterPos)/position;
else
    if absUnit == 0
        error('Position should not be empty!');
    elseif absUnit >obj.maxUnit
        error('Position in this market exceed limit');
    end
end

% determine result of transaction.
if (closePrice-avgCost)*obj.currUnit>0
    obj.lastWin = 1;
else
    obj.lastWin = 0;
end

% calculate commission
if obj.virtualOn
    commission = 0;
else
    commission = closePrice*obj.multiplier*abs(position)*obj.commissionRate;
end

obj.set_pos(obj.maxUnit);
position = 0;
avgCost = 0;

end

