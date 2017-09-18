function [ indHighWave ] = isHighWave( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P164
%% Parameters;
shadowLimit = 0.02*obj.zoomFactor;
barLenLimit = 0.005*obj.zoomFactor;
%%
indShadowUp = bars.lineLenUp./bars.open>shadowLimit;
indShadowDown = bars.lineLenDown./bars.open>shadowLimit;
indCross = ~(obj.isCross(bars));
indHammer = ~(obj.isHammer(bars));
indShootingStar = ~(obj.isShootingStar(bars));
indBarLen = bars.barLen./bars.open<barLenLimit;

indHighWave = indShootingStar&indCross&indHammer&indBarLen&(indShadowUp|indShadowDown);
end

