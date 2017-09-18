function [ obj ] = pushstr( obj, str)
% 向struct里填充l2数据，使用xml的默认顺序，逗号隔离
% 程刚，20151112

% 长度38， 37位是字符串，其他是数字
data = regexp(str,',','split');

for i  = 1:36
    d(i) = str2double(data{i});
end

%

% 取latest
t = obj.latest;
if isnan(t) %|| t == 0
    t = 1;
end
t = t+1;
obj.latest = t;


try 
obj.quoteTime(t)   = d(1);%     行情时间(s)
obj.dataStatus(t)  = d(2);%    DataStatus
obj.secCode{t}     = data{3};%证券代码
obj.accDeltaFlag(t)= d(4);%全量(1)/增量(2)
obj.preSettle(t)   = d(5);%昨日结算价
obj.settle(t)      = d(6);%今日结算价
obj.open(t)        = d(7);%开盘价
obj.high(t)    = d(8);%最高价
obj.low(t)     = d(9);%最低价
obj.last(t)    = d(10);%最新价
obj.close(t)   = d(11);%收盘价
obj.refP(t)    = d(12);%动态参考价格
obj.virQ(t)    = d(13);%虚拟匹配数量
obj.openInt(t) = d(14);%当前合约未平仓数
obj.bidQ1(t)   = d(15);%申买量1
obj.bidP1(t)   = d(16);%申买价1
obj.bidQ2(t)   = d(17);%申买量2
obj.bidP2(t)   = d(18);%申买价2
obj.bidQ3(t)   = d(19);%申买量3
obj.bidP3(t)   = d(20);%申买价3
obj.bidQ4(t)   = d(21);%申买量4
obj.bidP4(t)   = d(22);%申买价4
obj.bidQ5(t)   = d(23);%申买量5
obj.bidP5(t)   = d(24);%申买价5
obj.askQ1(t)   = d(25);%申卖量1
obj.askP1(t)   = d(26);%申卖价1
obj.askQ2(t)   = d(27);%申卖量2
obj.askP2(t)   = d(28);%申卖价2
obj.askQ3(t)   = d(29);%申卖量3
obj.askP3(t)   = d(30);%申卖价3
obj.askQ4(t)   = d(31);%申卖量4
obj.askP4(t)   = d(32);%申卖价4
obj.askQ5(t)   = d(33);%申卖量5
obj.askP5(t)   = d(34);%申卖价5
obj.volume(t)  = d(35);%成交数量
obj.amount(t)  = d(36);%成交金额
obj.rtflag{t}  = data{37};%产品实时阶段标志
obj.mktTime(t) = str2num(data{38});%市场时间(0.01s)
catch
    % 如失败，回滚
    obj.latest = obj.latest - 1;
end


end

