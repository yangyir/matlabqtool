function [ self ] = fillQuoteCTP(self)
% [ self ] = fillQuoteCTP(self)
%  [mktdata, level_p, update_time] = getoptquote(asset_code) 
%  其中mkt为 6*1 的数值向量，依次为最新价，开盘价，最高价，最低价，成交量, 昨收盘价
%  level_p 为买卖价格盘口数据（5*4矩阵）
%  update_time 是行情时间的字符串。
%-----------------------------
% 朱江 20160622 first draft
% 朱江 20170111 增加昨收
if self.srcId == -1
[mkt, level, updatetime] = getoptquote(num2str(self.code));
else
    [mkt, level, updatetime] = ctpgetquote_mex(self.srcId, num2str(self.code));
end

%标的最新价
s_mkt = getoptquote(num2str(self.underCode));
self.S = s_mkt(1);
self.last = mkt(1);%期权最新价
self.open = mkt(2);
self.high = mkt(3);
self.low = mkt(4);
self.diffVolume = mkt(5) - self.volume;%期权累计成交量增量
self.volume = mkt(5);%期权累计成交量
self.preClose = mkt(6);
self.preSettle = mkt(7);
self.quoteTime = updatetime;

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

self.askP1 = level(1,3);%申卖价1	
self.askQ1 = level(1,4);%申卖量1	
self.askP2 = level(2,3);%申卖价2	
self.askQ2 = level(2,4);%申卖量2	
self.askP3 = level(3,3);%申卖价3	
self.askQ3 = level(3,4);%申卖量3	
self.askP4 = level(4,3);%申卖价4	
self.askQ4 = level(4,4);%申卖量4	
self.askP5 = level(5,3);%申卖价5	
self.askQ5 = level(5,4);%申卖量5	

end