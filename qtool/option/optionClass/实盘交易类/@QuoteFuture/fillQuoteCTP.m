function [ self ] = fillQuoteCTP(self)
% [ self ] = fillQuoteCTP(self)
%  [mktdata, level_p, update_time] = getoptquote(asset_code) 
%  其中mkt为 5*1 的数值向量，依次为最新价，开盘价，最高价，最低价，成交量
%  level_p 为买卖价格盘口数据（5*4矩阵）
%  update_time 是行情时间的字符串。
%-----------------------------
% 朱江 20160622 first draft
if self.srcId == -1
[mkt, level, updatetime] = getoptquote(num2str(self.code));
else
    [mkt, level, updatetime] = ctpgetquote_mex(self.srcId, num2str(self.code));
end

%标的最新价
self.last = mkt(1);%期权最新价
self.open = mkt(2);
self.high = mkt(3);
self.low = mkt(4);
self.diffVolume = mkt(5) - self.volume;%期权累计成交量增量
self.volume = mkt(5);%期权累计成交量
self.quoteTime = updatetime;

self.bidP1 = level(1,1);%申买价1
self.bidQ1 = level(1,2);%申买量1
self.askP1 = level(1,3);%申卖价1	
self.askQ1 = level(1,4);%申卖量1	

end