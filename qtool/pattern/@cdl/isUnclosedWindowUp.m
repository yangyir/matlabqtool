function [ indUnclosedWindowUp ] = isUnclosedWindowUp(~, bars )
%%
% 《日本蜡烛图技术》，1998年5月第一版，P117
%% parameters
watchDay = 3;
%% 

indWindowUp = bars.low(2:end)>bars.high(1:end-1);
indWindowUp = [indWindowUp;0];

%% two algorithms of compute indUnclosed. Their time consumption are almost equal.
indWindowUp(end-watchDay+1:end) = 0;
indUnclosed = zeros(length(indWindowUp),1);
index = find(indWindowUp);

for i = 1:length(index)
    barIndex = index(i);
    if min(bars.low(barIndex+1:barIndex+watchDay))>bars.high(barIndex)
        indUnclosed(barIndex)=1;
    end
end

%{
daySpan = length(indWindowUp);
low = zeros(daySpan-watchDay,watchDay);
for i = 1:watchDay
    low(:,i)=bars.low(i+1:daySpan-watchDay+i);
end
indUnclosed = bars.high(1:end-watchDay)<min(low,[],2);
indUnclosed = [indUnclosed;zeros(watchDay,1)];
%}

indUnclosedWindowUp = indWindowUp&indUnclosed;
indUnclosedWindowUp = [zeros(watchDay,1);indUnclosedWindowUp(1:end-watchDay)];
end

