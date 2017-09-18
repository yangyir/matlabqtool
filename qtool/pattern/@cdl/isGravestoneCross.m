function [ indGravestoneCross ] = isGravestoneCross( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P166
%% parameters
upperShadowLimit = 0.005*obj.zoomFactor;
shadowRatio = 0.05;
%%
indCross = obj.isCross(bars);
indUpperShadow = bars.lineLenUp./bars.open>upperShadowLimit;
indLowerShadow = bars.lineLenDown./bars.lineLenUp<shadowRatio;

indGravestoneCross = indCross&indUpperShadow&indLowerShadow;

end

