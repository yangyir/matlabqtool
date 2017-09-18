function [ indHarami ] = isHarami(obj,  bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P83
%% parameters
% ratioLen is the ratio of the length of the first bar with that of the
% second.
ratioLen = 4;
% lenLimit is the threshold of the barLen of the first bar
lenLimit = 0.015*obj.zoomFactor;
%%

indCover = (bars.barCeil(1:end-1)>bars.barCeil(2:end))&(bars.barFloor(1:end-1)<bars.barFloor(2:end));
indLen = bars.barLen(1:end-1)./bars.open(1:end-1)>lenLimit;
indLenRatio = bars.barLen(1:end-1)./bars.barLen(2:end)>ratioLen;

indHarami = indCover&indLen&indLenRatio;

pSize = 2;
indHarami = [zeros(pSize-1,1);indHarami];

end

