function [ position, avgCost, commission] = add_pos( obj,spotPrice,posAdd)
%%
% Build or increment positions at spotPrice, and output current total
% position, average cost, and operation commission.
%%
% check direction and current unit
if obj.currUnit>0 && posAdd<0 || obj.currUnit<0 && posAdd>0
    error('Do not reduce position while using add_pos()!');
elseif posAdd == 0 
    error('Add 0 position');
end

if posAdd>0
    direction = 1;
else
    direction = -1;
end

% add Unit
if abs(obj.currUnit)<obj.maxUnit
    useableFund = obj.account*(obj.maxFER-obj.fundEmploymentRate);
    posIncrement = floor(useableFund/(spotPrice*obj.multiplier*obj.marginRate));    
    if posIncrement >0
        if posIncrement>abs(posAdd)
            posIncrement = abs(posAdd);
        end
        obj.currUnit = obj.currUnit+direction;
        absUnit = abs(obj.currUnit);
        obj.enterPos(absUnit) = posIncrement*direction;
        obj.enterPrice(absUnit) = spotPrice;
    else
        posIncrement = 0;
    end
else
    posIncrement = 0;
end

% check status after adding position.
if abs(obj.currUnit)>obj.maxUnit
    error('Exceed position unit limit! Add on unit per time!');
elseif abs(obj.currUnit)==0
    error('No position added!');
end

% return
if ~obj.virtualOn
    position = sum(obj.enterPos);
    avgCost = sum(obj.enterPrice.*obj.enterPos)/position;
    commission = spotPrice*posIncrement*obj.multiplier*obj.commissionRate;
else
    position = 0;
    avgCost = 0;
    commission = 0;
end

end

