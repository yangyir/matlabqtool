function [ indCross ] = isCross(obj, bars)
%%
% 《日本蜡烛图技术》，1998年5月第一版，P155
%%
% ratio of the barLen and open.
ratio = 0.0005*obj.zoomFactor;

indCross = (bars.barLen./bars.open<=ratio)&((bars.lineLenUp+bars.lineLenDown)>0);

end