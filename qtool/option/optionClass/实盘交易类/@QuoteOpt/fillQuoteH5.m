function [ self ] = fillQuoteH5( self )
% 取 单只期权 的实时行情数据， 填入到该期权的prof中
% --------------------------------
% 何康，20160108


% 登入连接行情服务器，返回为1时表示登录成功
% mktlogin
% pause(5)

% [mkt, level] = getCurrentPrice(code,marketNo);
% marketNo: 上海证券交易所='1';深交所='2'; 上交所期权='3';中金所='5'
% mkt: 5*1数值向量, 依次为最新价,成交量,交易状态(=0表示取到行情;=1表示未取到行情)，
% 交易分钟数,秒钟数，结算价，收盘价，市场类型
% level: 盘口数据(5*4矩阵), 第1~4列依次为委买价,委买量,委卖价,委卖量

% Level 对于五档行情的股票与期权来说，
% 买档数据为 第1行到第五行依次为买一到买五
% 卖档数据为 第五行到第一行依次为卖一到卖五， 逆序
% 对于期货这样一档行情的， 买卖档数据均在第一行排列。

%        bidQ1;%申买量1	
%        bidP1;%申买价1	
%        bidQ2;%申买量2	
%        bidP2;%申买价2
%        bidQ3;%申买量3	
%        bidP3;%申买价3	
%        bidQ4;%申买量4	
%        bidP4;%申买价4	
%        bidQ5;%申买量5	
%        bidP5;%申买价5	


[mkt, level] = getCurrentPrice(num2str(self.code),'3');
%标的最新价
%  underCode 应该是510050 而不是510050.SH否则无法获取行情
self.S = getCurrentPrice(num2str(self.underCode),'1');
self.S = self.S(1);
self.last = mkt(1);%期权最新价
self.diffVolume = mkt(2) - self.volume;%期权累计成交量增量
self.volume = mkt(2);%期权累计成交量
% 记录时间
L = length(mkt);
if L > 3
min = mkt(4);
sec = mkt(5);
self.min = min;
self.sec = sec;
% seconds = min * 60 + sec;
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

