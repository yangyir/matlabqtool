function [errorCode,errorMsg,entrustNo] = optPlaceEntrust(self, marketNo,stockCode,entrustDirection, futureDirection,entrustPrice,entrustAmount, coveredFlag)
%optPlaceEntrust ��CounterHSO32�����°�װEntrust����
%[errorCode,errorMsg,entrustNo] = optPlaceEntrust(marketNo, stockCode, entrustDirection, futureDirection, entrustPrice, entrustAmount, coveredFlag)
% ע��futureDirection��ƽ����
% --------------------------
% �콭��20160201

%% Ԥ����
if ~exist('coveredFlag' , 'var') ,  coveredFlag = '0' ; end



%% main
connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,entrustNo] = PlaceOptEntrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,futureDirection, entrustPrice,entrustAmount, coveredFlag);



end

