function [ indDarkCloudCover ] = isDarkCloudCover( obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P46
%% parameters
% Rising margin of the first bar
upThreshold = 0.015*obj.zoomFactor;
% Dropping margin of the second bar into the first one.
downThreshold =0.5;
%%
indRise = bars.barLen./bars.open>upThreshold;
indRise = indRise(1:end-1);
indCover = bars.open(2:end)>bars.high(1:end-1);
indDark = bars.barFloor(2:end)<bars.barCeil(1:end-1)-downThreshold*bars.barLen(1:end-1);

indDarkCloudCover = indRise&indCover&indDark;

pSize = 2;
indDarkCloudCover  = [zeros(pSize-1,1);indDarkCloudCover ];

end

