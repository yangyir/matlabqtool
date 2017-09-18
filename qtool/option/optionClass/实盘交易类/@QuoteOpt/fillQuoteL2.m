% [ self ] = fillQuoteL2(self, l2_str);
function [ self ] = fillQuoteL2( self, str)

% 长度38， 37位是字符串，其他是数字
% Data Sample:
% 行情时间(s)	DataStatus	证券代码	全量(1)/增量(2)	昨日结算价	今日结算价	开盘价	最高价	最低价	最新价	收盘价	动态参考价格	虚拟匹配数量	当前合约未平仓数	申买量1	申买价1	申买量2	申买价2	申买量3	申买价3	申买量4	申买价4	申买量5	申买价5	申卖量1	申卖价1	申卖量2	申卖价2	申卖量3	申卖价3	申卖量4	申卖价4	申卖量5	申卖价5	成交数量	成交金额	产品实时阶段标志	市场时间(0.01s)
% 83834,0,00000000,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, ,83833950
data = regexp(str,',','split');

for i  = 1:36
    d(i) = str2double(data{i});
end

%

t = self.latest;
if isempty(t)||isnan(t) || t == 0
    t = 1;
end

if (d(4) == 1) % 全量行情
    self.quoteTime   = data{1};%     行情时间(s)
    % self.dataStatus  = d(2);%    DataStatus
    % self.secCode     = data{3};%证券代码
    % self.accDeltaFlag= d(4);%全量(1)/增量(2)
    self.preSettle   = d(5);%昨日结算价
    % self.settle      = d(6);%今日结算价
    self.open        = d(7);%开盘价
    self.high    = d(8);%最高价
    self.low     = d(9);%最低价
    self.last    = d(10);%最新价
    self.close   = d(11);%收盘价
    self.refP    = d(12);%动态参考价格
    self.virQ    = d(13);%虚拟匹配数量
    self.openInt = d(14);%当前合约未平仓数
    self.bidQ1   = d(15);%申买量1
    self.bidP1   = d(16);%申买价1
    self.bidQ2   = d(17);%申买量2
    self.bidP2   = d(18);%申买价2
    self.bidQ3   = d(19);%申买量3
    self.bidP3   = d(20);%申买价3
    self.bidQ4   = d(21);%申买量4
    self.bidP4   = d(22);%申买价4
    self.bidQ5   = d(23);%申买量5
    self.bidP5   = d(24);%申买价5
    self.askQ1   = d(25);%申卖量1
    self.askP1   = d(26);%申卖价1
    self.askQ2   = d(27);%申卖量2
    self.askP2   = d(28);%申卖价2
    self.askQ3   = d(29);%申卖量3
    self.askP3   = d(30);%申卖价3
    self.askQ4   = d(31);%申卖量4
    self.askP4   = d(32);%申卖价4
    self.askQ5   = d(33);%申卖量5
    self.askP5   = d(34);%申卖价5
    self.diffVolume = d(35) - self.volume;
    self.volume  = d(35);%成交数量
    self.diffAmount = d(36) - self.amount;
    self.amount  = d(36);%成交金额
else %增量行情
    % 暂时不使用增量行情，避免更新太过频繁
end


end

