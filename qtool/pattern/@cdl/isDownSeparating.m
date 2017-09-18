function [ indDownSeparating ] = isDownSeparating(obj,  bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P153
%% parameter
errorLimit = 0.001*obj.zoomFactor;
%%
ind1 = bars.yinYang(1:end-1)==1;
ind2 = bars.yinYang(2:end)==-1;
indOpen = abs(bars.open(2:end)-bars.open(1:end-1))./bars.open(1:end-1)<errorLimit;
indBeltHold = obj.isBeltHoldDown(bars);
indBeltHold = indBeltHold(2:end);

indDownSeparating = ind1&ind2&indOpen&indBeltHold;
pSize = 2;
indDownSeparating = [zeros(pSize-1,1);indDownSeparating];
end

