function [ output_args ] = fillProfile( obj, profileBars, index )
%FILLPROFILE 把obj的最新截面放入profileBars（指针）中
% 输入：
%     profileBars     待被注入的截面（指针）
%     index         要提取的截面的编号，默认为obj.latest
% 没有输出，因为是注入
% 潘其超，程刚，140829

%% 
if ~exist('index', 'var')
    index    = obj.latest;
end

%%
try
    %% 几乎不会出错的域
    profileBars.latest  = index;
    profileBars.time    = obj.time(index);
    profileBars.open    = obj.open(index);
    profileBars.high    = obj.high(index);
    profileBars.low     = obj.low(index);
    profileBars.close   = obj.close(index);
    profileBars.volume  = obj.volume(index);
    profileBars.amount  = obj.amount(index);
    
    %% 很有可能出错的域
    profileBars.time2   = obj.time2(index);
catch e
end

%% 未必都有的域
try
profileBars.openInt = obj.openInt(index);
catch e
end

try
profileBars.tickNum = obj.tickNum(index);
catch e
end

end

