function [errorCode, errorMsg,cancelNo] = optEntrustCancel(self, entrustNo)
%optEntrustCancel ��CounterHSO32�����°�װ����EntrustsCancel
% [errorCode, errorMsg,cancelNo] = optEntrustCancel(self, entrustNo)
% --------------------------
% �콭��20160215

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode, errorMsg,cancelNo] = EntrustCancel( connection,token,combiNo,entrustNo, 3);
end
