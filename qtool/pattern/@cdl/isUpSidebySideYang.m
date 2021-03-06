function [ indUpSidebySideYang ] = isUpSidebySideYang(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P139
%% Parameters
floorLimit = 0.001*obj.zoomFactor;
lenLimit = 0.2;
%%
indFirstUp = bars.yinYang(1:end-2)==1;
indSecondUp = bars.yinYang(2:end-1)==1;
indThirdUp = bars.yinYang(3:end)==1;

indJump = bars.low(2:end-1)>bars.high(1:end-2);
indFloor = abs(bars.barFloor(2:end-1)-bars.barFloor(3:end))./bars.barFloor(2:end-1)<floorLimit;
indLen = abs(bars.barLen(2:end-1)-bars.barLen(3:end))./bars.barLen(2:end-1)<lenLimit;

indUpSidebySideYang = indFirstUp&indSecondUp&indThirdUp&indJump&indFloor&indLen;

pSize = 3;
indUpSidebySideYang = [zeros(pSize-1,1);indUpSidebySideYang];
end

