function [errorCode, errorMsg,cancelNo] = optEntrustCancel(self, entrustNo)
%optEntrustCancel 在CounterHSO32中重新包装函数EntrustsCancel
% [errorCode, errorMsg,cancelNo] = optEntrustCancel(self, entrustNo)
% --------------------------
% 朱江，20160215

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode, errorMsg,cancelNo] = EntrustCancel( connection,token,combiNo,entrustNo, 3);
end
