function [ indEngulfingUp ] = isEngulfingUp( obj,bars)
%%
% 《日本蜡烛图技术》，1998年5月第一版，P40
% RATIO = barLen(i+1)/barLen(i);
%% parameters
ratio = 1.5;
%%
indCover = (bars.barCeil(2:end)>bars.barCeil(1:end-1))&(bars.barFloor(2:end)<bars.barFloor(1:end-1));
indCross = obj.isCross(bars);
indCross = indCross(1:end-1);
indColor = (bars.yinYang(2:end)==1)&(bars.yinYang(1:end-1)==-1|indCross);
indLen = bars.barLen(2:end)>ratio*bars.barLen(1:end-1);

indEngulfingUp = indCover&indColor&indLen;

pSize = 2;
indEngulfingUp = [zeros(pSize-1,1);indEngulfingUp];

end
