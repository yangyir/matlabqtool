function [ self ] = fillQuoteL2( self, str)
% [ self ] = fillQuoteL2(l2_str);
% ��L2���������й���QuoteStock
% ����124, ��11��Ϊ�ַ���InstrumentStatus
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

if (d(4) == 1) % ȫ������
    self.quoteTime   = data{1};%     ����ʱ��(s)
    self.open        = d(6);%���̼�
    self.high    = d(7);%��߼�
    self.low     = d(8);%��ͼ�
    self.last    = d(9);%���¼�
    self.close   = d(10);%���̼�

    self.bidQ1   = d(46);%������1
    self.bidP1   = d(45);%�����1
    self.bidQ2   = d(46 + 4);%������2
    self.bidP2   = d(45 + 4);%�����2
    self.bidQ3   = d(46 + 2*4);%������3
    self.bidP3   = d(45 + 2*4);%�����3
    self.bidQ4   = d(46 + 3*4);%������4
    self.bidP4   = d(45 + 3*4);%�����4
    self.bidQ5   = d(46 + 4*4);%������5
    self.bidP5   = d(45 + 4*4);%�����5
    self.askQ1   = d(46 + 10*4);%������1
    self.askP1   = d(45 + 10*4);%������1
    self.askQ2   = d(46 + 11*4);%������2
    self.askP2   = d(45 + 11*4);%������2
    self.askQ3   = d(46 + 12*4);%������3
    self.askP3   = d(45 + 12*4);%������3
    self.askQ4   = d(46 + 13*4);%������4
    self.askP4   = d(45 + 13*4);%������4
    self.askQ5   = d(46 + 14*4);%������5
    self.askP5   = d(45 + 14*4);%������5
    self.diffVolume = d(13) - self.volume;
    self.volume  = d(13);%�ɽ�����
    self.diffAmount = d(14) - self.amount;
    self.amount  = d(14);%�ɽ����
else %��������
    % ��ʱ��ʹ���������飬�������̫��Ƶ��
end


end

