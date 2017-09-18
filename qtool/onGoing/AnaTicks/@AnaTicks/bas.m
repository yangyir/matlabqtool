function [ bid_ask_spread ] = bas( ticks, asklevel, bidlevel )
%BAS 计算买卖挂单的价差
% asklevel，第几档盘口
% bidlevel，第几档盘口
% chenggang; 140602

%% 预处理

if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end

if ~exist('asklevel','var'), asklevel = 1; end
if ~exist('bidlevel','var'), bidlevel = 1; end

ask = ticks.askP(1:ticks.latest, asklevel);
bid = ticks.bidP(1:ticks.latest, bidlevel);

%%
bid_ask_spread = ask - bid;

end

