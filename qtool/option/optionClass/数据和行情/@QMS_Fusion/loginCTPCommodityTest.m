function [ret] = loginCTPCommodityTest(obj)
% 登陆CTP商品期权测试账户
% wuyunfeng 20170525

obj.srcType  = 'CTP';
front_addr_  = 'tcp://ctpfz1-front1.citicsf.com:51213';
broker_id_   = '66666';
investor_id_ = '898710';
investor_password_ = '654321';
mdlogout;
pause(2);
ret = mdlogin(front_addr_, broker_id_, investor_id_, investor_password_);


end