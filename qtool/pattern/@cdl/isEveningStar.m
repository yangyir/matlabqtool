function [ indEveningStar ] = isEveningStar( obj,bars )
%% 
% 《日本蜡烛图技术》，1998年5月第一版，P61
%% parameters
pierceRatio = 0.5;
%%
indStar = obj.isStar(bars);
indStar = indStar(2:end-1);
indYinYang = (bars.yinYang(1:end-2)==1)&(bars.yinYang(3:end)==-1);
indPierce = bars.barFloor(3:end)<bars.barCeil(1:end-2)-pierceRatio*bars.barLen(1:end-2);

indEveningStar = indStar&indYinYang&indPierce;
pSize = 3;
indEveningStar= [zeros(pSize-1,1);indEveningStar];
end
