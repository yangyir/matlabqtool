function [ cash_t0, cash_t1 ] = queryCash( self )
%QUERYCASH 查询账户资金,使用了QueryCombiStock
%[ cash_t0, cash_t1 ] = queryCash( self )
% --------------------------
% 程刚，20160201

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);

if errorCode ~= 0
    disp(['查资金失败。错误信息为:',errorMsg]);
    return;
else
%     disp('-------------资金信息--------------');
%     PrintPacket2(packet); %打印资金信息

%         -------------资金信息--------------
%         [0]account_code	[0]202006
%         [1]asset_no	[1]820002006	
%         [2]enable_balance_t0	[2]136304.430000	
%         [3]enable_balance_t1	[3]140211.890000	
%         [4]current_balance	[4]140211.890000	

%     cash = packet.getDoubleByIndex(3);
    cash_t0 = packet.getDouble('enable_balance_t0');
    cash_t1 = packet.getDouble('enable_balance_t1');
%     fprintf('cash=%0.2f\n', cash);
end
end

