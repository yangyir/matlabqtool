function [ self ] = fillQuoteH5( self )
% 取 单只股票 的实时行情数据
% --------------------------------
% 朱江，20160317


% 登入连接行情服务器，返回为1时表示登录成功
% mktlogin
% pause(5)

% [mkt, level] = getCurrentPrice(code,marketNo);
% marketNo: 上海证券交易所='1';深交所='2'; 上交所期权='3';中金所='5'
% mkt: 5*1数值向量, 依次为最新价,成交量,交易状态(=0表示取到行情;=1表示未取到行情),交易分钟数,秒钟数
% level: 盘口数据(5*4矩阵), 第1~4列依次为委买价,委买量,委卖价,委卖量

if(strcmp(self.market, 'sh'))
    market = '1';
else
    market = '2';
end

[mkt, level] = getCurrentPrice(num2str(self.code), market);
%标的最新价
self.last = mkt(1);%股指期货最新价
self.diffVolume = mkt(2) - self.volume;%期货累计成交量增量
self.volume = mkt(2);%期货累计成交量

L = length(mkt);
if L > 3
min = mkt(4);
sec = mkt(5);
self.quoteTime = [num2str(min), ':', num2str(sec)];
end

if L > 5
    self.preClose  = mkt(6);
    self.preSettle = mkt(7);
    self.open      = mkt(8);
end

self.bidP1 = level(1,1);%申买价1
self.bidQ1 = level(1,2);%申买量1
self.bidP2 = level(2,1);%申买价2
self.bidQ2 = level(2,2);%申买量2
self.bidP3 = level(3,1);%申买价3
self.bidQ3 = level(3,2);%申买量3
self.bidP4 = level(4,1);%申买价4
self.bidQ4 = level(4,2);%申买量4
self.bidP5 = level(5,1);%申买价5
self.bidQ5 = level(5,2);%申买量5

self.askP1 = level(5,3);%申卖价1	
self.askQ1 = level(5,4);%申卖量1	
self.askP2 = level(4,3);%申卖价2	
self.askQ2 = level(4,4);%申卖量2	
self.askP3 = level(3,3);%申卖价3	
self.askQ3 = level(3,4);%申卖量3	
self.askP4 = level(2,3);%申卖价4	
self.askQ4 = level(2,4);%申卖量4	
self.askP5 = level(1,3);%申卖价5	
self.askQ5 = level(1,4);%申卖量5	




end