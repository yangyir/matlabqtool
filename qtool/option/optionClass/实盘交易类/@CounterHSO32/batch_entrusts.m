function [errorCode, errorMsg,entrustNoList, batchNo] = batch_entrusts(self, orderList)
%ENTRUST ��CounterHSO32�����°�װEntrust����
%[errorCode,errorMsg,entrustNo] = entrust(marketNo, stockCode, entrustDirection, entrustPrice, entrustAmount)
% --------------------------
% �̸գ�20160201


connection  = self.connection;
token       = self.token;

[errorCode, errorMsg,entrustNoList, batchNo] = Order(connection,token,orderList);



end

