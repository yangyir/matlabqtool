function [ indCrossAfterLongYang ] = isCrossAfterLongYang( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P51
%% parameters
longLenLimit = 0.01*obj.zoomFactor;
crossPosLimit = 0.3;
%%

indLongYang = (bars.close(1:end-1)-bars.open(1:end-1))./bars.open(1:end-1)>longLenLimit;
indCross = obj.isCross(bars);
indCross = indCross(2:end);
indCrossPos = bars.barFloor(2:end)>bars.barCeil(1:end-1)-crossPosLimit*bars.barLen(1:end-1);

indCrossAfterLongYang = indLongYang&indCross&indCrossPos;

pSize = 2;
indCrossAfterLongYang = [zeros(pSize-1,1);indCrossAfterLongYang];
end

