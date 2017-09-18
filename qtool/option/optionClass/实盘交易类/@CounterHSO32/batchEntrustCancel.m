function [errorCode, errorMsg,cancelNo] = batchEntrustCancel(self, batchNo)
%ENTRUSTCANCEL 在CounterHSO32中重新包装函数EntrustsCancel
% --------------------------
% 程刚，20160201

connection  = self.connection;
token       = self.token;

[errorCode, errorMsg,cancelNo] = BatchEntrustsCancel( connection,token, batchNo);
end
