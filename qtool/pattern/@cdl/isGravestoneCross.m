function [ indGravestoneCross ] = isGravestoneCross( obj, bars )
%%
% ���ձ�����ͼ��������1998��5�µ�һ�棬P166
%% parameters
upperShadowLimit = 0.005*obj.zoomFactor;
shadowRatio = 0.05;
%%
indCross = obj.isCross(bars);
indUpperShadow = bars.lineLenUp./bars.open>upperShadowLimit;
indLowerShadow = bars.lineLenDown./bars.lineLenUp<shadowRatio;

indGravestoneCross = indCross&indUpperShadow&indLowerShadow;

end

