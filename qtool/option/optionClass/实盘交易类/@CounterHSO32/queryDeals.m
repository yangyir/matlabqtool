function[errorCode,errorMsg,packet]  = queryDeals(self, entrustNo)
%QUERYDEALS ��CounterHSO32�����°�װ����QueryDeals
% --------------------------
% �̸գ�20160213

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;


[errorCode,errorMsg,packet] = QueryDeals(connection,token,accountCode,combiNo,entrustNo, 1);

% if errorCode < 0
%     disp(['��ɽ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%     pause(1);
% else
%     disp('-------------�ɽ���Ϣ--------------');
%     PrintPacket2(packet); %��ӡ�ɽ���Ϣ
% end
    
end

%         disp('-------------�ɽ���Ϣ--------------');
%         PrintPacket2(packet); %��ӡ�ɽ���Ϣ
%         -------------�ɽ���Ϣ--------------
%         [0]deal_date	[0]20151230
%         [1]deal_no	[1]2997242
%         [2]entrust_no	[2]62708
%         [3]extsystem_id	[3]0
%         [4]third_reff	[4]
%         [5]account_code	[5]202006
%         [6]asset_no	[6]820002006
%         [7]combi_no	[7]820002006-J
%         [8]instance_no	[8]
%         [9]stockholder_id	[9]D890798552
%         [10]market_no	[10]1
%         [11]stock_code	[11]510050
%         [12]entrust_direction	[12]1
%         [13]deal_amount	[13]100.000000
%         [14]deal_price	[14]2.419000
%         [15]deal_balance	[15]241.900000
%         [16]total_fee	[16]0.010000
%         [17]deal_time	[17]100922
%         [18]position_str	[18]119409
        
        