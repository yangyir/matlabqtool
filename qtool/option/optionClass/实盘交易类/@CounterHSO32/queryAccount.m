function [errorCode,errorMsg,packet] = queryAccount(self)
%QUERYACCOUNT ��CounterHSO32�����°�װ����QueryAccount
% --------------------------
% �̸գ�20160201


connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);

% 
% if errorCode < 0
%     disp(['���ʽ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%     return;
% else
%     disp('-------------�ʽ���Ϣ--------------');
%     PrintPacket2(packet); %��ӡ�ʽ���Ϣ
%     cash = packet.getDouble('enable_balance_t0');
% end


end

% 
%         -------------�ʽ���Ϣ--------------
%         [0]account_code	[0]202006
%         [1]asset_no	[1]820002006
%         [2]enable_balance_t0	[2]254044.200000
%         [3]enable_balance_t1	[3]254044.200000