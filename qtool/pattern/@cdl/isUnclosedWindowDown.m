function [ indUnclosedWindowDown ] = isUnclosedWindowDown(~, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P117
%% parameters
watchDay = 3;
%% 

indWindowDown = bars.high(2:end)<bars.low(1:end-1);
indWindowDown = [indWindowDown;0];

indWindowDown(end-watchDay+1:end) = 0;
indUnclosed = zeros(length(indWindowDown),1);
index = find(indWindowDown);

for i = 1:length(index)
    barIndex = index(i);
    if max(bars.high(barIndex+1:barIndex+watchDay))<bars.low(barIndex)
        indUnclosed(barIndex)=1;
    end
end


indUnclosedWindowDown = indWindowDown&indUnclosed;
indUnclosedWindowDown = [zeros(watchDay,1);indUnclosedWindowDown(1:end-watchDay)];

end

