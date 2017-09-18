function [errorCode,errorMsg,entrustNo] = optPlaceEntrust(self, marketNo,stockCode,entrustDirection, futureDirection,entrustPrice,entrustAmount, coveredFlag)
%optPlaceEntrust 在CounterHSO32中重新包装Entrust函数
%[errorCode,errorMsg,entrustNo] = optPlaceEntrust(marketNo, stockCode, entrustDirection, futureDirection, entrustPrice, entrustAmount, coveredFlag)
% 注：futureDirection开平方向
% --------------------------
% 朱江，20160201

%% 预处理
if ~exist('coveredFlag' , 'var') ,  coveredFlag = '0' ; end



%% main
connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,entrustNo] = PlaceOptEntrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,futureDirection, entrustPrice,entrustAmount, coveredFlag);



end

