function [errorCode, errorMsg,cancelNo] = batchEntrustCancel(self, batchNo)
%ENTRUSTCANCEL ��CounterHSO32�����°�װ����EntrustsCancel
% --------------------------
% �̸գ�20160201

connection  = self.connection;
token       = self.token;

[errorCode, errorMsg,cancelNo] = BatchEntrustsCancel( connection,token, batchNo);
end
