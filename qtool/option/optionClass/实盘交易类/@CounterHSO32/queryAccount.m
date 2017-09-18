function [errorCode,errorMsg,packet] = queryAccount(self)
%QUERYACCOUNT 在CounterHSO32中重新包装函数QueryAccount
% --------------------------
% 程刚，20160201


connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);

% 
% if errorCode < 0
%     disp(['查资金失败。错误信息为:',errorMsg]);
%     return;
% else
%     disp('-------------资金信息--------------');
%     PrintPacket2(packet); %打印资金信息
%     cash = packet.getDouble('enable_balance_t0');
% end


end

% 
%         -------------资金信息--------------
%         [0]account_code	[0]202006
%         [1]asset_no	[1]820002006
%         [2]enable_balance_t0	[2]254044.200000
%         [3]enable_balance_t1	[3]254044.200000