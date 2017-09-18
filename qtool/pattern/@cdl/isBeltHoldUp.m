function [ indBeltHoldUp ] = isBeltHoldUp( obj,bars )
%% 
% 《日本蜡烛图技术》，1998年5月第一版，P99
%% Parameters
lenLimit = 0.015*obj.zoomFactor;
shadowLimit = 0.01;
%%
indLen = bars.barLen./bars.open>lenLimit;

indDownLine = bars.lineLenDown./bars.barLen<shadowLimit;
indYang = bars.yinYang==1;
indBeltHoldUp = indLen&indYang&indDownLine;

end

