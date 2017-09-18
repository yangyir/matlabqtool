function [ indWindow ] = isWindow(~, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P123
%%
indWindowUp = bars.low(2:end)>bars.high(1:end-1);
indWindowDown = bars.high(2:end)<bars.low(1:end-1);
indWindow = indWindowUp|indWindowDown;
indWindow = vertcat(0,indWindow);


end

