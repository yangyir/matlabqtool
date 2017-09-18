function [errorCode,errorMsg,packet] = queryOptMargin(self)
% 期权查询保证金的方法
% --------------------------
% 吴云峰，20170106


connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;
marketNo    = '1';


[errorCode, errorMsg,packet] = QueryOptMargin(connection,token,accountCode,combiNo,marketNo);







end

% PrintPacket3(packet)
% ans =
% [0]account_code	[0]2034	
% [1]asset_no	[1]82002006	
% [2]occupy_deposit_balance	[2]0.000000	
% [3]enable_deposit_balance	[3]119789601.500000	
% 使用方法
% packet.getDouble('occupy_deposit_balance')
% packet.getDouble('enable_deposit_balance')
