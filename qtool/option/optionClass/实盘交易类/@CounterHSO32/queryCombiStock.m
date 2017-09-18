function [errorCode,errorMsg,packet] = queryCombiStock(self,marketNo,stockCode)
%QUERYCOMBISTOCK 在CounterHSO32中重新包装函数QueryCombiStock
% --------------------------
% 程刚，20160201


connection  = self.connection;
token       = self.token;
accountCode = self.accountCode;
combiNo     = self.combiNo;

[errorCode,errorMsg,packet] = QueryCombiAsset(connection,token,accountCode,combiNo,marketNo,stockCode, 1);


% 附加，未必写在里面
if errorCode < 0
    disp(['查持仓失败。错误信息为:',errorMsg]);
    return;
else
%     disp('-------------获得持仓信息--------------');
%     PrintPacket2(packet); %打印持仓信息
end

end


%     disp('-------------持仓信息--------------');
%     PrintPacket2(packet); %打印持仓信息
%         -------------持仓信息--------------
%         [0]account_code	[0]202006
%         [1]asset_no	[1]820002006
%         [2]combi_no	[2]820002006-J
%         [3]market_no	[3]1
%         [4]stock_code	[4]510050
%         [5]option_type	[5]
%         [6]stockholder_id	[6]D890798552
%         [7]hold_seat	[7]25744
%         [8]position_flag	[8]1
%         [9]invest_type	[9]1
%         [10]current_amount	[10]23200.000000
%         [11]enable_amount	[11]23100.000000
%         [12]begin_cost	[12]56891.600000
%         [13]current_cost	[13]57133.500000
%         [14]current_cost_price	[14]2.463000
%         [15]pre_buy_amount	[15]0.000000
%         [16]pre_sell_amount	[16]0.000000
%         [17]pre_buy_balance	[17]0.000000
%         [18]pre_sell_balance	[18]0.000000
%         [19]today_buy_amount	[19]100.000000
%         [20]today_sell_amount	[20]0.000000
%         [21]today_buy_balance	[21]241.900000
%         [22]today_sell_balance	[22]0.000000
%         [23]today_buy_fee	[23]0.000000
%         [24]today_sell_fee	[24]0.000000
%         [25]buy_amount	[25]100.000000
%         [26]sell_amount	[26]0.000000
%         [27]buy_balance	[27]241.900000
%         [28]sell_balance	[28]0.000000
%         [29]buy_fee	[29]0.000000
%         [30]sell_fee	[30]0.000000