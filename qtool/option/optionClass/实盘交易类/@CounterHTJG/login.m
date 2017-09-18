function [ ] = login( self )
%LOGIN 连接、登陆
% -----------------------------------
% 朱江，20170323

[counter_id, ret] = jg_counterlogin(self.serverAddr, self.port, self.investor, self.investorPassword);

self.counterId = counter_id;

% 柜台已经登录
self.is_Counter_Login = ret;


end

