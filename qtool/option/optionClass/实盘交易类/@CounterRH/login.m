function [ ] = login( self )
%LOGIN ���ӡ���½
% -----------------------------------
% �콭��20160621

[counter_id, ret, available_entrust_Id] = rhcounterlogin(self.serverAddr, self.broker, self.investor, self.investorPassword, self.product_info, self.authentic_code);

self.counterId = counter_id;

% ��̨�Ѿ���¼
self.is_Counter_Login = ret;
self.SetAvailableEntrustId(available_entrust_Id);


end

