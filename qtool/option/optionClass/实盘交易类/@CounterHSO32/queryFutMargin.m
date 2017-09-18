function [errorCode,errorMsg,packet] = queryFutMargin(self)
% 期货查询保证金的方法
% function [errorCode,errorMsg,packet] = queryFutMargin(self)
% --------------------------
% 吴云峰，20170106


connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;


[errorCode, errorMsg,packet] = QueryFutMargin(connection,token,accountCode,combiNo);






end

% PrintPacket3(packet)
% ans =
% [0]account_code	[0]2016	
% [1]asset_no	[1]82000016	
% [2]occupy_deposit_balance	[2]0.000000	
% [3]enable_deposit_balance	[3]1011370429.120000	
% [4]futu_deposit_balance	[4]1011370429.120000	
% [5]futu_temp_occupy_deposit	[5]0.000000
% packet.getDouble('occupy_deposit_balance')
% packet.getDouble('enable_deposit_balance')