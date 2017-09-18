function [errorCode,errorMsg,packet] = queryFutEntrusts(self, entrustNo)
%QUERYENTRUST 在CounterHSO32中重新包装函数QueryEntrusts
% --------------------------
% 朱江，20160316

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo, 2);

% if errorCode < 0
%     disp(['查委托失败。错误信息为:',errorMsg]);
%     pause(1);
%     break;
% else
%     disp('-------------委托信息--------------');
%     PrintPacket2(packet); %打印委托信息
% end


end
% 
%         disp('-------------委托信息--------------');
%         PrintPacket2(packet); %打印委托信息
%         -------------委托信息--------------
%         [0]entrust_date	[0]20160216	
%         [1]entrust_time	[1]101954	
%         [2]operator_no	[2]2038	
%         [3]batch_no	[3]195389	
%         [4]entrust_no	[4]154170	
%         [5]report_no	[5]57	
%         [6]extsystem_id	[6]0	
%         [7]third_reff	[7]	
%         [8]account_code	[8]202006	
%         [9]asset_no	[9]820002006	
%         [10]combi_no	[10]820002006-J	
%         [11]instance_no	[11]	
%         [12]stockholder_id	[12]D890798552	
%         [13]report_seat	[13]25744	
%         [14]market_no	[14]1	
%         [15]stock_code	[15]10000535	
%         [16]stock_name	[16]50ETF购6月2000	
%         [17]option_type	[17]C	
%         [18]entrust_direction	[18]1	
%         [19]futures_direction	[19]1	
%         [20]price_type	[20]0	
%         [21]entrust_price	[21]0.125000	
%         [22]entrust_amount	[22]1.000000	
%         [23]pre_buy_frozen_balance	[23]1250.300000	
%         [24]pre_sell_balance	[24]0.000000	
%         [25]confirm_no	[25]0	
%         [26]covered_flag	[26]0	
%         [27]entrust_state	[27]3	
%         [28]first_deal_time	[28]0	
%         [29]deal_amount	[29]0.000000	
%         [30]deal_balance	[30]0.000000	
%         [31]deal_price	[31]0.000000	
%         [32]deal_times	[32]0	
%         [33]withdraw_amount	[33]0.000000	
%         [34]withdraw_cause	[34]	
%         [35]position_str	[35]154170	
%         [36]exchange_report_no	[36]57	
%         [37]revoke_cause	[37]	