function [ ] = login( self )
%LOGIN ���ӡ���½
% -----------------------------------
% �콭��20170323

[counter_id, ret] = jg_counterlogin(self.serverAddr, self.port, self.investor, self.investorPassword);

self.counterId = counter_id;

% ��̨�Ѿ���¼
self.is_Counter_Login = ret;


end

