function [ indUpsideGapYinyang ] = isUpsideGapYinyang(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P134
%%
indWindow = obj.isWindow(bars);
indWindow = indWindow(2:end-1);
indRise = bars.barFloor(2:end-1)>bars.barCeil(1:end-2);

indFirstYang = bars.yinYang(2:end-1)==1;
indSecondYin = bars.yinYang(3:end)==-1;
indOverlap = (bars.barCeil(3:end)<bars.barCeil(2:end-1))&(bars.barCeil(3:end)>bars.barFloor(2:end-1))&(bars.barFloor(3:end)<bars.barFloor(2:end-1));

indUpsideGapYinyang = indWindow&indFirstYang&indSecondYin&indOverlap&indRise;

pSize = 3;
indUpsideGapYinyang = [zeros(pSize-1,1);indUpsideGapYinyang];

end

