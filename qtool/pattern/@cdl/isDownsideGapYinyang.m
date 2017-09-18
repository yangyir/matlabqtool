function [ indDownsideGapYinyang ] = isDownsideGapYinyang( obj,bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P134
%%
indWindow = obj.isWindow(bars);
indWindow = indWindow(2:end-1);
indDrop = bars.barFloor(1:end-2)>bars.barCeil(2:end-1);

indFirstYin = bars.yinYang(2:end-1)==-1;
indSecondYang = bars.yinYang(3:end)==1;
indOverlap = (bars.barFloor(3:end)<bars.barCeil(2:end-1))&(bars.barFloor(3:end)>bars.barFloor(2:end-1))&(bars.barCeil(3:end)>bars.barCeil(2:end-1));

indDownsideGapYinyang = indWindow&indFirstYin&indSecondYang&indOverlap&indDrop;

pSize = 3;
indDownsideGapYinyang = [zeros(pSize-1,1);indDownsideGapYinyang];
end

