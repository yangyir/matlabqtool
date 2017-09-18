function [errorCode, errorMsg,entrustNoList, batchNo] = batch_entrusts(self, orderList)
%ENTRUST 在CounterHSO32中重新包装Entrust函数
%[errorCode,errorMsg,entrustNo] = entrust(marketNo, stockCode, entrustDirection, entrustPrice, entrustAmount)
% --------------------------
% 程刚，20160201


connection  = self.connection;
token       = self.token;

[errorCode, errorMsg,entrustNoList, batchNo] = Order(connection,token,orderList);



end

