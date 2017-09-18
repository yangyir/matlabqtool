function [ position, avgCost, commission ] = flop_pos(obj, spotPrice, posNew )
%    Close current positions and build opposite positions, return latest
%    position, avgCost and total commissions.
%%
% determine direction of new position
if obj.currUnit>0
    posNew = - posNew;
end

[~,~,commission1] = obj.close_pos(spotPrice);
obj.fundEmploymentRate = 0;
obj.account = obj.account - commission1;
[position,avgCost,commission2] = obj.add_pos(spotPrice,posNew);
commission = commission1+commission2;

end

