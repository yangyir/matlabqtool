function [ self ] = fillQuoteH5( self )
% 取 单只股指期货 的实时行情数据， 填入到该期权的prof中
% --------------------------------
% 何康，20160108
% 朱江，20160314


% 登入连接行情服务器，返回为1时表示登录成功
% mktlogin
% pause(5)

% [mkt, level] = getCurrentPrice(code,marketNo);
% marketNo: 上海证券交易所='1';深交所='2'; 上交所期权='3';中金所='5'
% mkt: 5*1数值向量, 依次为最新价,成交量,交易状态(=0表示取到行情;=1表示未取到行情),交易分钟数,秒钟数
% level: 盘口数据(5*4矩阵), 第1~4列依次为委买价,委买量,委卖价,委卖量


[mkt, level] = getCurrentPrice(num2str(self.code),'5');
%标的最新价
self.last = mkt(1);%股指期货最新价
self.diffVolume = mkt(2) - self.volume;%期货累计成交量增量
self.volume = mkt(2);%期货累计成交量
% 记录时间
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
self.askP1 = level(1,3);%申卖价1	
self.askQ1 = level(1,4);%申卖量1	


end

