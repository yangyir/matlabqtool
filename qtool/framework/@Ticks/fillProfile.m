function [ ] = fillProfile( obj, profileTicks, tkIndex )
%FILLPROFILE 把obj的最新截面放入profileTicks（指针）中
% 输入：
%     profileTicks    待被注入的截面（指针）
%     tkIndex         要提取的截面的编号，默认为obj.latest
% 没有输出，因为是注入
% 潘其超，程刚，140829


if ~exist('tkIndex', 'var')
    tkIndex    = obj.latest;
end

%         ts_fields = {'time', 'time2', 'last', 'high'

try
%% 这些几无可能出错
profileTicks.latest  =  tkIndex;
profileTicks.time    = obj.time(tkIndex);
profileTicks.last    = obj.last(tkIndex);
profileTicks.volume  = obj.volume(tkIndex);
profileTicks.amount  = obj.amount(tkIndex);

%% 这些可能出错
profileTicks.askP(1,:) = obj.askP(tkIndex,:);
profileTicks.askV(1,:) = obj.askV(tkIndex,:);
profileTicks.bidP(1,:) = obj.bidP(tkIndex,:);
profileTicks.bidV(1,:) = obj.bidV(tkIndex,:);

%% 这些极有可能出错
profileTicks.time2   = obj.time2(tkIndex);

catch e
end

%% 这个只有future有
try
    profileTicks.openInt = obj.openInt(tkIndex);
catch e
end




%% 这些都是可能出错的
try
    profileTicks.high    = obj.high(tkIndex);
    profileTicks.low     = obj.low(tkIndex);
catch e
end

% try
%     profileTicks.time2   = obj.time2(tkIndex);
% catch e
% end



end

