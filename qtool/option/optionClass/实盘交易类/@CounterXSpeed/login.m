function [ ] = login( self )
%LOGIN ���ӡ���½
% -----------------------------------
% �콭��20160621

[counter_id, ret] = xspeedcounterlogin(self.serverAddr, self.investor, self.investorPassword, self.logfile);

self.counterId = counter_id;

% ��̨�Ѿ���¼
self.is_Counter_Login = ret;


end

