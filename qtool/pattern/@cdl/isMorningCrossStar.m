function [ indMorningCrossStar ] = isMorningCrossStar(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P67
%%
indMorningStar = obj.isMorningStar(bars);
indCross = obj.isCross(bars);
indCross = [0;indCross(1:end-1)];

indMorningCrossStar = indMorningStar&indCross;

end

