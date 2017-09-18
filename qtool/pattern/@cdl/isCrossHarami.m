function [ indCrossHarami ] = isCrossHarami(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P89
%%
indHarami = obj.isHarami(bars);
indCross = obj.isCross(bars);

indCrossHarami = indCross&indHarami;

end

