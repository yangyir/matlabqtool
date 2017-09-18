function [errorCode,errorMsg,packet] = queryEntrusts(self, entrustNo)
%QUERYENTRUST 在CounterHSO32中重新包装函数QueryEntrusts
% --------------------------
% 程刚，20160201

connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryEntrusts(connection,token,accountCode,combiNo,entrustNo, 1);

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
%         [0]entrust_date	[0]20151230
%         [1]entrust_time	[1]100922
%         [2]operator_no	[2]2038
%         [3]batch_no	[3]96505
%         [4]entrust_no	[4]62708
%         [5]report_no	[5]184
%         [6]extsystem_id	[6]0
%         [7]third_reff	[7]
%         [8]account_code	[8]202006
%         [9]asset_no	[9]820002006
%         [10]combi_no	[10]820002006-J
%         [11]instance_no	[11]
%         [12]stockholder_id	[12]D890798552
%         [13]report_seat	[13]25744
%         [14]market_no	[14]1
%         [15]stock_code	[15]510050
%         [16]entrust_direction	[16]1
%         [17]price_type	[17]0
%         [18]entrust_price	[18]2.463000
%         [19]entrust_amount	[19]100.000000
%         [20]pre_buy_frozen_balance	[20]0.000000
%         [21]pre_sell_balance	[21]0.000000
%         [22]confirm_no	[22]173
%         [23]entrust_state	[23]7
%         [24]first_deal_time	[24]100922
%         [25]deal_amount	[25]100.000000
%         [26]deal_balance	[26]241.900000
%         [27]deal_price	[27]2.420000
%         [28]deal_times	[28]1
%         [29]withdraw_amount	[29]0.000000
%         [30]withdraw_cause	[30]
%         [31]position_str	[31]62708
%         [32]exchange_report_no	[32]184
