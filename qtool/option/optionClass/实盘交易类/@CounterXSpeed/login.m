function [ ] = login( self )
%LOGIN 连接、登陆
% -----------------------------------
% 朱江，20160621

[counter_id, ret] = xspeedcounterlogin(self.serverAddr, self.investor, self.investorPassword, self.logfile);

self.counterId = counter_id;

% 柜台已经登录
self.is_Counter_Login = ret;


end

