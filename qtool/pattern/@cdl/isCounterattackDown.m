function [ indCounterattackDown ] = isCounterattackDown( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P107
%% parameters 
firstSwingLimit = 0.01*obj.zoomFactor;
jumpLimit = 0.01*obj.zoomFactor;
overlapLimit = 0.002*obj.zoomFactor;
%%
ind1Up = (bars.close(1:end-1)-bars.open(1:end-1))./bars.open(1:end-1)>firstSwingLimit;
ind2JumpUp = (bars.open(2:end)-bars.close(1:end-1))./bars.close(1:end-1)>jumpLimit;
indOverlapDown = abs(bars.close(2:end)-bars.close(1:end-1))./bars.close(1:end-1)<overlapLimit;

indCounterattackDown = ind1Up&ind2JumpUp&indOverlapDown;

pSize = 2;
indCounterattackDown= [zeros(pSize-1,1); indCounterattackDown];

end

