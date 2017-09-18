function [ indPiercingDown ] = isPiercingDown( obj,bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P51
%% parameters
% rising margin of the first bar
riseThreshold = 0.015*obj.zoomFactor;
% dropping margin of the second bar into the first one.
downThreshold =0.5;
%%
ind1yang = bars.yinYang(1:end-1)==1;
indUp = bars.barLen./bars.open>riseThreshold;
indUp = indUp(1:end-1);
indCover = bars.open(2:end)>bars.high(1:end-1);
indPierce = bars.barFloor(2:end)<bars.barCeil(1:end-1)-downThreshold*bars.barLen(1:end-1);

indPiercingDown = ind1yang&indUp&indCover&indPierce; 
indPiercingDown = [0;indPiercingDown];

end