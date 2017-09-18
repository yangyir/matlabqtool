function [ indRickshaw ] = isRickshaw(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P164
%%
errorLimit = 0.2;
indLongLeggedCross = obj.isLongLeggedCross(bars);
indMiddle = abs(bars.lineLenUp./bars.lineLenDown-1)<errorLimit;

indRickshaw = indLongLeggedCross&indMiddle;

end

