function [ indTweezerBottom ] = isTweezerBottom(obj, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P91
%% Parameters
gapRatio = 0.0005*obj.zoomFactor;
%%
ind12 = abs(bars.low(1:end-1)-bars.low(2:end))<gapRatio*bars.low(1:end-1);
indHalt = obj.isHalt(bars);
indHalt = indHalt(2:end);

indTweezerBottom = ind12&(~indHalt);

pSize = 2;
indTweezerBottom = [zeros(pSize-1,1);indTweezerBottom];

end

