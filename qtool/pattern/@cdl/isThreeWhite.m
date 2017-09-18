function [ indThreeWhite ] = isThreeWhite(obj, bars )
%% 
% 《日本蜡烛图技术》，1998年5月第一版，P151
%% Parameters
upShadowLimit = 0.001*obj.zoomFactor;
%%
ind1 = (bars.yinYang(1:end-2)==1)&bars.lineLenUp(1:end-2)./bars.barCeil(1:end-2)<upShadowLimit;
ind2 = (bars.yinYang(2:end-1)==1)&bars.lineLenUp(2:end-1)./bars.barCeil(2:end-1)<upShadowLimit;
ind3 = (bars.yinYang(3:end)==1)&bars.lineLenUp(3:end)./bars.barCeil(3:end)<upShadowLimit;

indLadder = bars.close(1:end-2)<bars.close(2:end-1)&bars.close(2:end-1)<bars.close(3:end);
ind12 = bars.open(2:end-1)>bars.open(1:end-2)&bars.open(2:end-1)<bars.close(1:end-2);
ind23 = bars.open(3:end)>bars.open(2:end-1)&bars.open(3:end)<bars.close(2:end-1);

indThreeWhite = ind1&ind2&ind3&ind12&ind23&indLadder;

pSize = 3;
indThreeWhite = [zeros(pSize-1,1);indThreeWhite];
end

