function [ cash_t0, cash_t1 ] = queryCash( self )
%QUERYCASH ��ѯ�˻��ʽ�,ʹ����QueryCombiStock
%[ cash_t0, cash_t1 ] = queryCash( self )
% --------------------------
% �̸գ�20160201

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);

if errorCode ~= 0
    disp(['���ʽ�ʧ�ܡ�������ϢΪ:',errorMsg]);
    return;
else
%     disp('-------------�ʽ���Ϣ--------------');
%     PrintPacket2(packet); %��ӡ�ʽ���Ϣ

%         -------------�ʽ���Ϣ--------------
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

