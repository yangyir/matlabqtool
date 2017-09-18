% clear;
% clc;
%%
%         cost:        单向交易成本，为成本占交易标的金额的比例。至少应包括佣金，
%                      也可适当加大，以反应冲击成本。
%         leverage：   杠杆率，一般为一个在[1,8]之间的数值，为交易金额相对于计划金额
%                      的放大倍率。
%         lag：        信号延迟单位，默认值为1,为一个正整数。lag=N，当下产生的交易信号将在N个
%                      时间切片之后成交。信号延迟的确定需要根据实际的交易时滞来确定。
%         orderStyle:  下单风格，默认值为0.
%                      orderStyle = 0，根据signal计算出的交易量下单。
%                      orderStyle = 1, 根据signal判断交易方向，每次只下1手。
%         initValue：  初始账户金额，应全部为现金。
%         multiplier： 合约乘数。
%         marginRate： 期货交易所规定的最低保证金比例。
%         riskfreebench： 
%                      年化无风险利率。
%         varmethod：  计算风险价值的方法，目前只提供一种方法，默认值为1；
%         vara：       可能损失超出风险价值的最大概率。1-vara是风险价值的置信水平。
%                      默认值0.05.
%         riskIndex：  计算风险系数的开关，默认值为1.
%                      riskIndex = 1，计算风险系数。
%                      riskIndex = 0，不计算风险系数。
%    
% 按照上面的说明配置参数：
configure.cost = 0.0003;
configure.leverage = 3;
configure.lag = 1;
configure.initValue = 1e5;
configure.multiplier = 300;
configure.marginRate = 0.12;
configure.riskfreebench = 0.03;
configure.varmethod = 1;
configure.vara = 0.05;
configure.riskIndex = 1;
configure.orderStyle = 1;
signal = importdata('signal.mat');
bars = importdata('barSample.mat');

%%
result = backtestF(signal,bars, configure);