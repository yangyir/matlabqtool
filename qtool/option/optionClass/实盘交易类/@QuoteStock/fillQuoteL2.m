function [ self ] = fillQuoteL2( self, str)
% [ self ] = fillQuoteL2(l2_str);
% 从L2行情数据中构建QuoteStock
% 长度124, 第11个为字符串InstrumentStatus
% Data Sample:
% DataTimeStamp,DataStatus,SecurityID,ImageStatus,PreClosePx,OpenPx,HighPx,LowPx,LastPx,ClosePx,InstrumentStatus,NumTrades,TotalVolumeTrade,TotalValueTrade,TotalBidQty,WeightedAvgBidPx,AltWeightedAvgBidPx,TotalOfferQty,WeightedAvgOfferPx,AltWeightedAvgOfferPx,IOPV,ETFBuyNumber,ETFBuyAmount,ETFBuyMoney,ETFSellNumber,ETFSellAmount,ETFSellMoney,YieldToMaturity,TotalWarrantExecQty,WarLowerPx,WarUpperPx,WithdrawBuyNumber,WithdrawBuyAmount,WithdrawBuyMoney,WithdrawSellNumber,WithdrawSellAmount,WithdrawSellMoney,TotalBidNumber,TotalOfferNumber,BidTradeMaxDuration,OfferTradeMaxDuration,NumBidOrders,NumOfferOrders,BidLevels,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,OfferLevels,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
% 92512,0,510050,1,3.018,3.048,3.048,3.048,3.048,0,BETW,598,1.37455e+007,4.18962e+007,1.44928e+007,2.91,0,5.0264e+007,3.183,0,3.053,0,0,0,0,0,0,0,0,0,0,25,998700,3.03973e+006,45,5.9562e+006,1.81925e+007,744,1689,0,0,187,231,0,3.048,1.59372e+006,21,0,3.047,2500,3,0,3.046,30000,1,0,3.045,3900,4,0,3.044,1000,1,0,3.04,52500,8,0,3.038,38000,1,0,3.036,3000,1,0,3.031,1000,1,0,3.03,74200,7,0,3.049,41100,5,0,3.05,509200,50,0,3.051,3000,2,0,3.052,12300,4,0,3.053,103200,4,0,3.054,1900,2,0,3.055,235900,17,0,3.056,10500,2,0,3.057,41200,6,0,3.058,566200,10,

data = regexp(str,',','split');

for i  = [1:10, 12:123]
    d(i) = str2double(data{i});
end

%

t = self.latest;
if isempty(t)||isnan(t) || t == 0
    t = 1;
end

if (d(4) == 1) % 全量行情
    self.quoteTime   = data{1};%     行情时间(s)
    self.open        = d(6);%开盘价
    self.high    = d(7);%最高价
    self.low     = d(8);%最低价
    self.last    = d(9);%最新价
    self.close   = d(10);%收盘价

    self.bidQ1   = d(46);%申买量1
    self.bidP1   = d(45);%申买价1
    self.bidQ2   = d(46 + 4);%申买量2
    self.bidP2   = d(45 + 4);%申买价2
    self.bidQ3   = d(46 + 2*4);%申买量3
    self.bidP3   = d(45 + 2*4);%申买价3
    self.bidQ4   = d(46 + 3*4);%申买量4
    self.bidP4   = d(45 + 3*4);%申买价4
    self.bidQ5   = d(46 + 4*4);%申买量5
    self.bidP5   = d(45 + 4*4);%申买价5
    self.askQ1   = d(46 + 10*4);%申卖量1
    self.askP1   = d(45 + 10*4);%申卖价1
    self.askQ2   = d(46 + 11*4);%申卖量2
    self.askP2   = d(45 + 11*4);%申卖价2
    self.askQ3   = d(46 + 12*4);%申卖量3
    self.askP3   = d(45 + 12*4);%申卖价3
    self.askQ4   = d(46 + 13*4);%申卖量4
    self.askP4   = d(45 + 13*4);%申卖价4
    self.askQ5   = d(46 + 14*4);%申卖量5
    self.askP5   = d(45 + 14*4);%申卖价5
    self.diffVolume = d(13) - self.volume;
    self.volume  = d(13);%成交数量
    self.diffAmount = d(14) - self.amount;
    self.amount  = d(14);%成交金额
else %增量行情
    % 暂时不使用增量行情，避免更新太过频繁
end


end

