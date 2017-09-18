function [waiting, waiting_tk] = r( ticks,t,limitprice,direction, flag_strict, latency   )
% 估计给定限价的成交等待时间（回测用）
% inputs:
%       ticks0,         Ticks类
%       t,              限价点，matlab格式时间
%       price,          限价
%       direction,      方向，1为买，-1为卖
%       flag_strict,    是否严格判断成交条件 （ >  和 >= 在区别）
% version 1.0, luhuaibao
% 2014.5.29


%% 默认值
if ~exist('flag_strict', 'var'), flag_strict = 0 ;  end
if ~exist('latency', 'var'), latency = 0.5/24/3600; end

% 浮点数比大小时有误差，加上epsilon，不改变a>b的结果
% a>b    <=>   a>b+epsilon
% a<b    <=>   a<b-epsilon
% a>=b   <=>   a>=b-epsilon  <=>  a>b-epsilon
% a<=b   <=>   a<=b+epsilon  <=>  a<b+epsilon
epsilon = 1e-5;


%%
% disp('r计算时，默认volume是递增的，请确保ticks的volume递增');


% tic

%% 取下单后在第一个tk
time = ticks.time(1:ticks.latest);
% 严格大于，因下单需要传递时间
order_tk = find(time > t+latency , 1, 'first');



%% 从order_tk开始取
time = ticks.time(order_tk:ticks.latest);
bidP = ticks.bidP(order_tk:ticks.latest,1);
askP = ticks.askP(order_tk:ticks.latest,1);
last = ticks.last(order_tk:ticks.latest);
volume = [ticks.volume(order_tk); diff(ticks.volume(order_tk:ticks.latest,1))];



%% 判断可以成交
if flag_strict == 1
    if direction == 1  % 下买单bid
        idx =  ( last < limitprice-epsilon & volume>0 ) | askP <= limitprice+epsilon;
    elseif direction == -1  % 卖单ask
        idx =  ( last > limitprice+epsilon & volume>0 ) | bidP >= limitprice-epsilon;
    end
elseif flag_strict == 0
    if direction == 1  % 下买单bid
        idx =  ( last <= limitprice+epsilon & volume>0 ) | askP <= limitprice+epsilon;
    elseif direction == -1  % 卖单ask
        idx =  ( last >= limitprice-epsilon & volume>0 ) | bidP >= limitprice-epsilon;
    end
end


%% 计算等待时间
waiting_tk = find( idx == 1, 1, 'first');

% 未能成交处理
if isempty(waiting_tk)
    waiting     = nan;
    waiting_tk  = nan;
%     toc;
    return;
end

success_t = time(waiting_tk);
waiting = success_t - t;

% 减去中午90分钟
if t-floor(t) <= 11.5/24
    if success_t - floor( success_t ) >= 13/24
        waiting = waiting - 1.5/24;
    end
end

waiting = waiting * 24 * 3600;    
% toc

end

