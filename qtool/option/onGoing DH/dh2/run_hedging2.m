clear all; rehash;

h2 = Deltahedging2();


% h2.counter.login();
h2.init_real_account_setting()
h2.get_current_price();
h2.init_option_setting(0.05, 2.20, '2016-03-25', 0.25, 'call');
h2.update_portfolio();

h2.cal_delta(); %再把init_option_setting中的past_delta赋值为当前delta？

h2.BS_option_price();
 

% pause(60)

%% 循环 1

% TODO： 用什么来控制循环 ？ 取系统时间？
iter = 0;
while 1 && iter<200
    
h2.get_current_price();
%h1.current_underling_price = 2.43;
h2.cal_delta();



h2.openfire();
% TODO：如果下单不成功，还有很复杂的处理

iter = iter +1;
iter
% pause(60);

% TODO: 更新一下交易信息
h2.update_portfolio;


% TODO：记录状态—— 当前时间，S价格，S数量，交易数量，交易fee，理论callPrice
%       记录状态 已完成

% TODO：实盘有交易fee

end


%退出登录
h2.logout();


%% 循环 2

% TODO： 用什么来控制循环 ？ 取系统时间？
%while 1
    
h2.get_current_price();
h2.cal_delta();



h2.openfire();
% TODO：如果下单不成功，还有很复杂的处理


pause(120);

% TODO：记录状态—— 当前时间，S价格，S数量，交易数量，交易fee，理论callPrice
%       记录状态 已完成

% TODO：实盘有交易fee

%end
%% 输出和分析

% 可以把记录copy至excel，在excel中做分析




