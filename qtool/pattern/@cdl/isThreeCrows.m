function [ indThreeCrows ] = isThreeCrows( obj,bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P105
%% parameters
downLineRatio = 0.001*obj.zoomFactor;
%%
ind1yang = bars.yinYang(1:end-3)==1;
ind2yin = bars.yinYang(2:end-2)==-1;
ind3yin = bars.yinYang(3:end-1)==-1;
ind4yin = bars.yinYang(4:end)==-1;
% high of the first white bar larger than the second barCeil.
ind12 = bars.high(1:end-3)>bars.barCeil(2:end-2);
ind23 = (bars.barCeil(3:end-1)<bars.barCeil(2:end-2))&(bars.barCeil(3:end-1)>bars.barFloor(2:end-2));
ind34 = (bars.barCeil(4:end)<bars.barCeil(3:end-1))&(bars.barCeil(4:end)>bars.barFloor(3:end-1));

indShadow2 = bars.lineLenDown(2:end-2)./bars.barFloor(2:end-2)<downLineRatio;
indShadow3 = bars.lineLenDown(3:end-1)./bars.barFloor(3:end-1)<downLineRatio;
indShadow4 = bars.lineLenDown(4:end)./bars.barFloor(4:end)<downLineRatio;

indThreeCrows = ind1yang&ind2yin&ind3yin&ind4yin&ind12&ind23&ind34&indShadow2&indShadow3&indShadow4;

pSize = 4;
indThreeCrows = [zeros(pSize-1,1);indThreeCrows];
end

