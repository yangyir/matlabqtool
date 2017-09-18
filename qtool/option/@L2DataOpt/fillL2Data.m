function [ obj ] = fillL2Data( obj, str)
% 向struct里填充l2数据，使用xml的默认顺序


% 长度38， 37位是字符串，其他是数字
data = regexp(str,',','split');

for i  = 1:36
    d(i) = str2double(data{i});
end

% 

t = obj.latest;
if isempty(t)||isnan(t) || t == 0
    t = 1;
end

obj.quoteTime   = d(1);%     行情时间(s)
obj.dataStatus  = d(2);%    DataStatus
obj.secCode     = data{3};%证券代码
obj.accDeltaFlag= d(4);%全量(1)/增量(2)
obj.preSettle   = d(5);%昨日结算价
obj.settle      = d(6);%今日结算价
obj.open        = d(7);%开盘价
obj.high    = d(8);%最高价
obj.low     = d(9);%最低价
obj.last    = d(10);%最新价
obj.close   = d(11);%收盘价
obj.refP    = d(12);%动态参考价格
obj.virQ    = d(13);%虚拟匹配数量
obj.openInt = d(14);%当前合约未平仓数
obj.bidQ1   = d(15);%申买量1
obj.bidP1   = d(16);%申买价1
obj.bidQ2   = d(17);%申买量2
obj.bidP2   = d(18);%申买价2
obj.bidQ3   = d(19);%申买量3
obj.bidP3   = d(20);%申买价3
obj.bidQ4   = d(21);%申买量4
obj.bidP4   = d(22);%申买价4
obj.bidQ5   = d(23);%申买量5
obj.bidP5   = d(24);%申买价5
obj.askQ1   = d(25);%申卖量1
obj.askP1   = d(26);%申卖价1
obj.askQ2   = d(27);%申卖量2
obj.askP2   = d(28);%申卖价2
obj.askQ3   = d(29);%申卖量3
obj.askP3   = d(30);%申卖价3
obj.askQ4   = d(31);%申卖量4
obj.askP4   = d(32);%申卖价4
obj.askQ5   = d(33);%申卖量5
obj.askP5   = d(34);%申卖价5
obj.volume  = d(35);%成交数量
obj.amount  = d(36);%成交金额
obj.rtflag  = data{37};%产品实时阶段标志
obj.mktTime = str2num(data{38});%市场时间(0.01s)



end

