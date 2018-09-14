%% mex file generate
mex -g rh_counter_login.cpp
mex -g rh_counter_loadentrusts.cpp
mex -g rh_counter_loadtrades.cpp
mex -g rh_counter_getaccountinfo.cpp
mex -g rh_counter_getpositions.cpp
mex -g rh_counter_querysettleinfo.cpp
mex -g rh_counter_logout.cpp
mex -g rh_counter_qryaccount.cpp
mex -g rh_counter_mdlogin.cpp
mex -g rh_counter_mdlogout.cpp
mex -g rh_counter_withdrawoptentrust.cpp
mex -g rh_counter_queryoptentrust.cpp
mex -g rh_counter_placeoptentrust.cpp
mex -g rh_counter_getoptquote.cpp
mex -g rh_counter_faketest.cpp
%mex -g rh_counter_testmd.cpp

%% 登录
% 融航：
%  yy02 密码 123123
%  192.168.41.194 10001 交易
%                10006 行情
%  实盘brokerid=RohonReal
%  模拟盘brokerid=RohonDemo
etf_front_addr = 'tcp://120.136.134.132:10001';
etf_broker = 'RohonDemo';
etf_investor = 'jxqhly01';
etf_pwd = '888888';
product_info = '';
authen_code = '';
counter_id = rh_counter_login(etf_front_addr, etf_broker, etf_investor, etf_pwd,product_info,authen_code);

%% rh_counter_loadtrades
%查询成交信息
[trades, ret] = ctp_counter_loadtrades(counter_id)


%% [trades, ret] = ctp_counter_loadtrades(counter_id)
%查询所有委托信息
[entrusts, ret] = rh_counter_loadentrusts(counter_id)


%% rh_counter_getaccountinfo
%qry account info
[account, ret] = rh_counter_getaccountinfo(counter_id);
account
if ~ret
    disp('查询资金失败');
end

%% 查询持仓信息  依然存在bug 朱江正在解决中
[positions, ret] = rh_counter_getpositions(counter_id,'');
positions
if ~ret
    disp('查询持仓失败');
end

%%
% 下单
% direction : 1 = buy , 2 = sell
% offset : 1 = open, 2 = close;
entrust_id = 4; %委托编号 本地维护
asset_type = 1;
code = 'ni1810'
direction = 1;
offset = 1;
price = 102180;
amount = 1;

[ret, sysid] = rh_counter_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
sysid


%% 查询委托
[dealinfo] = rh_counter_queryoptentrust(counter_id, entrust_id);
dealinfo


%% rh_counter_withdrawoptentrust
% 委托撤单
[ret] = rh_counter_withdrawoptentrust(counter_id , entrust_id)

%% 挂单撤单测试
i  = 100 %测试次数
while(i)
    i = i - 1;
    % 挂单
    % direction : 1 = buy , 2 = sell
    % offset : 1 = open, 2 = close;
    entrust_id = i; %委托编号 本地维护
    asset_type = 1;
    code = 'ni1810'
    if mod(i,2) == 0
        direction = 1;
        offset = 1;
        price = 102000;
    else
        direction = 2;
        offset = 1;
        price = 103000;
    end
    amount = 1;
    [ret, sysid] = rh_counter_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
    pause(1)
    sysid
    % 委托撤单
    [ret] = rh_counter_withdrawoptentrust(counter_id , entrust_id)
    pause(1)
    

end


%% 登出
ret = rh_counter_logout(counter_id);




%% 测试md

clear all; rehash;

front_addr_ = 'tcp://125.64.36.26:52213';
broker_id_ = '2001';
investor_id_ = '8880000052';
investor_password_ = '123456';

ret = rh_counter_mdlogin(front_addr_, broker_id_, investor_id_, investor_password_);


%% 获取行情
[mkt, level, update_time] = rh_counter_getoptquote('rb1810');



