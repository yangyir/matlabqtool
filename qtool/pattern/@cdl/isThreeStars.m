function [ indThreeStar ] = isThreeStars(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P170
% We make the criteria a little loose here.
%%
indCross = obj.isCross(bars);
indCross = indCross(1:end-2)&indCross(2:end-1)&indCross(3:end);

indStarHigh = (bars.barFloor(2:end-1)>bars.barCeil(1:end-2))&(bars.barFloor(2:end-1)>bars.barCeil(3:end));
indStarLow = (bars.barCeil(2:end-1)<bars.barFloor(1:end-2))&(bars.barCeil(2:end-1)<bars.barFloor(3:end));

indThreeStar = indCross&(indStarHigh|indStarLow);

pSize = 3;
indThreeStar = [zeros(pSize-1,1);indThreeStar];
end