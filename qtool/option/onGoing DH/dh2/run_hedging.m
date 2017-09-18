clear all; rehash;

h1 = Deltahedging1();


% h1.init_trading_setting();
h1.init_real_account_setting();
h1.get_current_price();
h1.init_option_setting();
h1.update_portfolio();

h1.cal_delta(); %再把init_option_setting中的past_delta赋值为当前delta？


 

% pause(60)

%% 循环 1

% TODO： 用什么来控制循环 ？ 取系统时间？
iter = 0;
while 1 && iter<200
    
h1.get_current_price();
%h1.current_underling_price = 2.43;
h1.cal_delta();



h1.openfire();
% TODO：如果下单不成功，还有很复杂的处理

iter = iter +1;
iter
% pause(60);

% TODO: 更新一下交易信息
h1.update_portfolio;


% TODO：记录状态—— 当前时间，S价格，S数量，交易数量，交易fee，理论callPrice
%       记录状态 已完成

% TODO：实盘有交易fee

end


%退出登录
h1.logout();


%% 循环 2

% TODO： 用什么来控制循环 ？ 取系统时间？
%while 1
    
h1.get_current_price();
h1.cal_delta();



h1.openfire();
% TODO：如果下单不成功，还有很复杂的处理


pause(120);

% TODO：记录状态—— 当前时间，S价格，S数量，交易数量，交易fee，理论callPrice
%       记录状态 已完成

% TODO：实盘有交易fee

%end
%% 输出和分析

% 可以把记录copy至excel，在excel中做分析




