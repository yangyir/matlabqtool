function [ indCounterattackUp ] = isCounterattackUp(obj,  bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P107
%% parameters
firstSwingLimit = 0.01*obj.zoomFactor;
jumpLimit = 0.01*obj.zoomFactor;
overlapLimit = 0.002*obj.zoomFactor;
%%
ind1Drop = (bars.open(1:end-1)-bars.close(1:end-1))./bars.open(1:end-1)>firstSwingLimit;
ind2JumpDown = (bars.close(1:end-1)-bars.open(2:end))./bars.close(1:end-1)>jumpLimit;
indOverlapUp = abs(bars.close(2:end)-bars.close(1:end-1))./bars.close(1:end-1)<overlapLimit;

indCounterattackUp = ind1Drop&ind2JumpDown&indOverlapUp;

pSize = 2;
indCounterattackUp= [zeros(pSize-1,1); indCounterattackUp];
end

