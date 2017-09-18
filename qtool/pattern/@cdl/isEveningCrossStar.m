function [ indEveningCrossStar ] = isEveningCrossStar(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P67
%%
indEveningStar = obj.isEveningStar(bars);
indCross = obj.isCross(bars);
indCross = [0;indCross(1:end-1)];

indEveningCrossStar = indEveningStar&indCross;
end

