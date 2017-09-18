function [ indLongLeggedCross ] = isLongLeggedCross( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P164
%% Parameters
legLimit = 0.01*obj.zoomFactor;
%%
indCross = obj.isCross(bars);
indLongLeg = bars.lineLenUp./bars.open>legLimit & bars.lineLenDown./bars.open>legLimit;

indLongLeggedCross = indCross&indLongLeg;


end

