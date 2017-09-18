function [DisplayData] = backtestF_v6(signal, bars, configure)
%% Backtest 根据百分比仓位信号评价策略在期货市场表现。
% 【概要】：
% 该函数包括6个模块：
% 1. 核心计算：根据输入参数计算净值，仓位，操作，手续费的时间序列，以及交易清单。
%             接下都是基于这些计算量的分析。
% 2. 基于账户净值的分析：收益率，最大回撤，资金占用率等指标。
% 3. 基于切片收益率的分析：盈利/亏损切片数，连续盈利/亏损切片数，风险收益指标等。
% 4. 基于日收益序列的分析：将切片收益率转化为日收益率，并做简单统计。
% 5. 基于交易清单的分析：将一个 开仓-关仓 或者 加仓-减仓 过程定义为一个完整的交易，
%             对交易序列进行统计分析。
% 6. 输出：将分析结果保存到mat文件和xlsx文件。
%
% 【输入参数】：
% SIGNAL: 百分比仓位信号，为一个N*1的时间序列。信号值应在[-1,1]区间内。
%         根据信号值的变动来确定该时刻是否发出下单指令。
%         程序根据信号值算出该时刻的下单量，根据配置参数(configure.lag)将成交信号
%         向后延迟。比如：
%         signal = [0,1,1,0,0], configure.lag = 2;
%         第二个时间点产生下单信号，根据此刻的净值，信号和收盘价格计算出目标仓位，目标仓位
%         与当前仓位的差值即为下单量，差值为正下多单，反之空单。信号延迟量为2，则这个指令
%         在第4个时间点以开盘价成交。
% 
% BARS：  行情切片信息,为一个Bars对象。至少应该包括完整的high, low, close, open, vwap, time.
%         如果分析数据包含多日行情，需要将行情连接起来，即每个维度只有一个向量。连接的时候无需
%         对日间跳跃做任何调整。
%
% CONFIGURE：配置参数，为一个结构体，除有默认值的参数外，其他参数都要赋值。
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
%         min_open:    最多开仓手数
%         max_open:    最多开仓手数
%         safepos：    最低保证金比例
%     
% 【输出参数】：
% 所有的输出均保存在DisplayData的结构体中，除Detail域外，其他所有域都输入到
% cd\res\BackTestResult.xlsx，每个域是一个worksheet.
% DisplayData结构如下:
% Main: 策略绩效概要：
%     净值的初始值/最高值/最低值/最终值，总交易费用，资产净值增长
%     最大回撤(百分比），最大回撤发生的开始/结束时间，最长回撤期（时间切片数），最长回撤期结束时间，
%     净利，毛利，毛损，平均盈亏，调整净利/毛利/毛损，
%     平均盈亏除以平均亏损，总盈利除以总亏损，胜率，败率，
%     单次交易最大盈利百分比，单次交易最大亏损百分比，
%     最大盈利占毛利百分比，最大亏损占毛损百分比，
%     净利润除以毛损，最大持续盈利交易次数，最大持续亏损交易次数，最大资金占用率
%     剔除最大盈利交易后的收益率，剔除最大亏损交易后的收益率，
%     剔除前N%盈利交易后的收益率，剔除前N%亏损交易后的收益率，
%     标准化后的最终净值
%   
% Detail: 交易的时间序列记录：
%     净值（包含交易费用），不包含交易费用的净值，净值收益率，交易费用
%     买入，卖出，卖空，补空的状态，分在4个向量中，每个向量对应一种操作的状态。
%     没有操作为0，对买入和补空，有操作为1；对卖出和卖空有操作为-1.
%     每笔交易个标准化收益、每日标准化收益
%
% Trading：交易分析：
%     总交易次数，盈利交易次数，亏损交易次数，
%     盈利交易的平均盈利，亏损交易的平均亏损，盈利交易次数占总交易次数之比
%
% Period: 区间统计：
%     总交易切片数，有交易的切片数，交易频率（有交易的切片数/总交易切片数），
%     处于盈利状态的切片数（相对于上一个切片），处于亏损状态的切片数（相对于上一个切片），
%     最大连续盈利切片数，最大连续亏损切片数
%     平均交易周期，平均获胜交易周期，平均亏损交易周期
%
% StatisticalIndex： 统计量：
%     交易时间跨度（自然天），交易时间跨度（交易日），资产净值方差系数，资产净值标准差
%     最终回报率，日收益率的均值，方差，偏度，峰度。 
%
% RiskIndex:总收益
%     最终回报率，年化波动率，年化sharp，年化omegaC,年化sortinoRatio,年化calmarRatio,
%     年化sterlingRatio,年化burkeRatio
% 
% 【Example】:
% [DisplayData] = Backtest(signal, bars, configure)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ChenJie, V1.0, 针对股票组合的回测。
% 
% Qichao Pan, Han Wu, 2013/04/19, V2.0
% 改为针对期货的回测
% 
% Qichao Pan, 2013/04/2, V3.0
% 全面检测，精简结构，优化算法，添加注释
% 
% LXY, 2013/08/16 , V4.0
% 针对股指期货，每次只交易一手
% 修改sortino ratio、每笔交易的收益、每日收益、最大回撤、
% 策略在一倍杠杆下的最后净值
% 根据上述改动更新了盈亏比的算法
% 新指标中标准化的定义为：相对当时开仓成本的收益等。

% LXY, 2013/08/21 , V4.1
% 针对股指期货，增加了 每次可以交易不多于最大策略容量的手数 的模式
% 主要升级了3个计算函数，加入了按开仓手数给出信号的计算模式
% 增加了 最少开仓手数、最多开仓手数、最低保证金比例2个输入变量
% 为配合新的计算模式（每次给出交易手数style2），修正了部分输出变量
% 解决了SOA因每日切片数目报错的BUG
% 因为模式三手数并非1手，重新加入了总资产最大回撤的输出

% LXY, 2013/08/24 , V4.2
% 加入第四种计算模式（每次给出杠杆倍数style3）

%GX,2013/9/1,V5.1
%针对加仓情况，采用先进先出，分大交易，每笔交易，每手交易三张tradeList,tradeLists,tradeListh
%基本指标针对tradeListh计算，胜率既有每笔胜率，也有每手胜率

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%
Time = bars.time;
if configure.orderStyle == 2
    signal(abs(signal)<configure.min_open) =...
        sign(signal(abs(signal)<configure.min_open))*configure.min_open;   
    signal(abs(signal)>configure.max_open)=...
        sign(signal(abs(signal)>configure.max_open))*configure.max_open;   
end
%% 核心计算
% 计算每个时间切片下的成交量，成交额，资产净值，交易费用，不计交易成本的资产价值，头寸规模
[volume,account,tradingCost,accountNoCost,position,signal_adj] = calc_account_v2(bars,signal, configure);
% 计算每个时间切片下买入，卖出，卖空，补空的状态
[sig_buy,sig_sell, sig_sellShort, sig_buy2Cover] = calc_buysellmark(signal,configure);

% 计算每次交易的起始时间，损益情况，买卖方向
% tradeList:大交易（tradereturn,方向，开始时间，结束时间，盈利数，笔数，手数）
% tradeLists:每笔交易（tradereturn,方向，开始时间，结束时间，盈利数，手数，如果一笔中有多个平仓时点，则算作不同的笔数）
% tradeListh:每手交易（tradereturn,方向，开始时间，结束时间，盈利数，手数）
[tradeList] = calc_tradeList_v2( signal,account,Time,bars,configure);
[tradeLists,tradeListh]=calc_tradeList_sv2(signal,account,Time,bars,configure,tradeList);

%% 基于账户净值的分析

% 初始资产总值/最终资产总值/资产最大值/资产最小值
DisplayData.Main.initAccount = account(1,1); 
DisplayData.Main.finalAccount = account(end,1);
DisplayData.Main.maxAccount = max(account);
DisplayData.Main.minAccount = min(account);
% 交易费用加总
DisplayData.Main.cost = sum(tradingCost); 
% 资产净值的增长
DisplayData.Main.netGain = account(end)/account(1)-1; 

% 最大回撤、最大回撤比 最大回撤周期以及它们对应的时间
[maxDDR,MDDs,MDDe,maxDDD,m_index3] = calculateMaxDD(account, bars, configure);
DisplayData.Main.maxDDR_asset = calculateMaxDD_asset(account);%考虑初始资金的回撤
DisplayData.Main.maxDrawdown =maxDDR;               % 最大回撤（收益）
DisplayData.Main.maxDrawdownBegT = MDDs;  % 最大回撤（收益）的开始时间
DisplayData.Main.maxDrawdownEndT = MDDe;  % 最大回撤（收益）的开始时间
DisplayData.Main.longestDrawdownDuration =maxDDD;       % 最大回撤期（bar数）
DisplayData.Main.longestDdrawdownEndT =datestr(Time(m_index3),31);       % 最大回撤期（bar数）结束时间

% 资产净值： 标准差/（均值-初始值）, 资产净值的标准差
[DisplayData.StatisticalIndex.CoefficientOfVariance,DisplayData.StatisticalIndex.StandardDeviation] =...
    CalcCoefficientofvariance (account); 

% 最大资金占用率
DisplayData.Main.maxUsedFundRatio =...
    max(abs(position.*bars.close*configure.marginRate*configure.multiplier)./account);

% Buysellpoint 买卖清单
DisplayData.oprnList.data = calc_buysellpoint(bars,account,volume,configure); % 输出到BuySellPoint 主表

DisplayData.Detail.account = account;        % 资产组合净值的时间序列（扣除交易费用）
DisplayData.Detail.position = position; 
DisplayData.Detail.volume = volume; 
DisplayData.Detail.accountNoCost = accountNoCost;   %资产组合的无交易费净值 （假设交易费用为0） 
DisplayData.Detail.tradingCost = tradingCost;  % 资产组合交易费用的时间序列
DisplayData.Detail.sig_buy = sig_buy;          % 记录每次多仓开仓信号的时间序列（多开的时间序列）
DisplayData.Detail.sig_sell = sig_sell;          % 记录每次多仓平仓信号的时间序列（多平的时间序列）
DisplayData.Detail.sig_sellShort = sig_sellShort;  % 记录每次空仓开仓信号的时间序列（空开的时间序列）
DisplayData.Detail.sig_buy2Cover = sig_buy2Cover;  % 记录每次空仓平仓信号的时间序列（空平的时间序列）
DisplayData.Detail.tradeList = tradeList; 
DisplayData.Detail.tradeLists= tradeLists;
DisplayData.Detail.tradeListh= tradeListh;

%130816 加入：
% 每次交易标准化收益 gap
[nrow,~] = size(tradeList);
DisplayData.Detail.gap = zeros(nrow,1);

for i = 1:nrow
    gap_temp = account(bars.time == tradeList(i,4)) -...
        account(bars.time == tradeList(i,3));
    DisplayData.Detail.gap(i) = gap_temp / (configure.multiplier *...
        bars.open(find(bars.time == tradeList(i,3))+1) *...
        (1 + configure.cost) * configure.min_open);
end

% 每次交易标准化收益 gap
%DisplayData.Detail.gap_perhand = DisplayData.Detail.gap./tradeList(:,7)...
   % *configure.min_open;

% 每日标准化收益 rev

days = floor(Time);
DaySlice = find(days(2:end)~=days(1),1);
[nrow,~] = size(account);
DisplayData.Detail.rev = zeros(nrow/DaySlice,1);

for i = 1:length(DisplayData.Detail.rev)
    rev_temp = account(DaySlice*i) - account(DaySlice*(i-1)+1);
    DisplayData.Detail.rev(i) = rev_temp / (configure.multiplier *...
        mean(bars.close((DaySlice*(i-1)+1):(DaySlice*i))));
end

% final NAV
    
DisplayData.Main.finalNAV = (account(end)-account(1))/account(1);

%% 基于切片收益率的分析

returns_slice=diff(account)./account(1:end-1);   % 每个bar的收益率，时间序列
DisplayData.Detail.returns_slice=returns_slice;        

% 获得正收益的bar的个数，获得负收益的bar的个数
DisplayData.Period.win_slices = sum(returns_slice>0);   % 获得正收益的bar个数，即判读正确的bar个数
DisplayData.Period.lose_slices = sum(returns_slice<0);  % 获得负收益的bar个数，即判读错误的bar个数

% 最大连续盈利bar数和亏损bar数
[DisplayData.Period.maxConWinSlices,DisplayData.Period.maxConLoseSlices] = CalculatemaxConSGN(returns_slice) ; 

% 测试时间长度　bar数
DisplayData.Period.totalSlices =length(Time); 

% 有交易的bar数
DisplayData.Period.transSlices =sum(diff(position)~=0); 

% 有交易的bar数/测试总bar数
DisplayData.Period.transFrequ = DisplayData.Period.transSlices/DisplayData.Period.totalSlices; 

% 风险收益系数
R = returns_slice;
rf = configure.riskfreebench;
timeSlice = mode(diff(Time));
slicesPerDay = 1/24*4.5/timeSlice;
Rf = rf/(250*slicesPerDay);
Rf = Rf*ones(size(R));

if configure.riskIndex ==1
%     % 输出到RiskIndex 绩效评估和风险指标
%     a = configure.vara;
%     varmethod = configure.varmethod;
%     %     计算VaR 目前只有方差协方差法，其余方法下次升级加入
%     switch varmethod
%         case 1
%             DisplayData.RiskIndex.VaR = portvrisk(mean(R),std(R),a);
%         case 2
%         case 3
%         case 4
%         otherwise
%     end

    DisplayData.RiskIndex.TotalReturn = account(end)/account(1)-1;
    DisplayData.RiskIndex.annstd =annualizestdev(R,slicesPerDay);
    DisplayData.RiskIndex.sharperatio = SharpeRatio( R,Rf,slicesPerDay);    % R 每日整个资产净值的收益率。 Rf risk-free rate.
    DisplayData.RiskIndex.omegaC = omegaCoefficient( R,Rf);
%    DisplayData.RiskIndex.SoRa = sortinoRatio( R,Rf,DaySlice);
    DisplayData.RiskIndex.calmarR = calmarRatio( R,Rf,slicesPerDay);
    % DisplayData.RiskIndex.kappaC = kappa3(R,Rf);
    DisplayData.RiskIndex.sterlingR = sterlingRatio( R,Rf,slicesPerDay);
    DisplayData.RiskIndex.burkeR = burkeRatio( R,Rf,slicesPerDay );
    % DisplayData.RiskIndex.conditionalSharpeR = conditionalSharpe( R,Rf,DisplayData.RiskIndex.VaR);
    % DisplayData.RiskIndex.modifiedSharpeR = modifiedSharpe( R,Rf,DisplayData.RiskIndex.VaR );
    % DisplayData.RiskIndex.exRetVaR = excessReturnOnVaR( R,Rf,DisplayData.RiskIndex.VaR);
end


%% 基于日收益率的分析

% 日收益率序列,将bar为计算单位归纳为日收益率计算。
returns_day = calc_series_returns(account,bars.time);

% 交易时间跨度（日）统计
tradingdate = unique(floor(bars.time));
DisplayData.StatisticalIndex.testdayNatural = floor(tradingdate(end))-floor(tradingdate(1))+1;
DisplayData.StatisticalIndex.testdayTrading = length(tradingdate);

% 以日计算的收益率均值和波动率
DisplayData.StatisticalIndex.returns_day_m = mean(returns_day(:,2));
DisplayData.StatisticalIndex.returns_day_s = std(returns_day(:,2));
DisplayData.StatisticalIndex.returns_day_kur = kurtosis(returns_day(:,2));  % 峰度 大于3比正态分布要陡峭，小于3比正态分布要平坦
DisplayData.StatisticalIndex.returns_day_ske = skewness(returns_day(:,2));  % 偏度 小于0左偏态，大于0右偏态
DisplayData.StatisticalIndex.TotalReturn = account(end)/account(1)-1;


%% 交易分析，基于tradeList 和 tradeReturn 的分析

% 交易回报单
 tradeReturns=tradeListh(:,6);   
 winIndex = find(tradeReturns>0);
 loseIndex = find(tradeReturns<0);

% 计算盈亏比, 函数已经考虑了交易费用。
[DisplayData.Trading.gainNum,...
    DisplayData.Trading.lossNum,...
    DisplayData.Trading.tradeNum,...
    DisplayData.Trading.avgGain,...
    DisplayData.Trading.avgLoss,...
    DisplayData.Trading.winRatio] = calc_winloseratio(tradeListh);



% 毛盈
 DisplayData.Main.grossWin = sum(tradeReturns(tradeReturns>0)); 
 
% 毛亏
 DisplayData.Main.grossLose = sum(tradeReturns(tradeReturns<0)); 
 
% 净利，平均盈亏
 DisplayData.Main.netprofit = sum(tradeReturns); 
 DisplayData.Main.avgWinLose = mean(tradeReturns); 
 
% 平均盈利除以平均亏损
 DisplayData.Main.aveWinDivideAveLoss = DisplayData.Trading.avgGain/...
     DisplayData.Trading.avgLoss;
  
% 总盈利除以总亏损
 DisplayData.Main.groWinDivideGroLoss =DisplayData.Main.grossWin/DisplayData.Main.grossLose;

% 盈利比率
 DisplayData.Main.winRate = length(winIndex)/length(tradeReturns);
 DisplayData.Main.winRates=sum(tradeLists(:,6)>0)/size(tradeLists,1);
 
% 亏损比率
 DisplayData.Main.loseRate = length(loseIndex)/length(tradeReturns);

% 平均交易周期
DisplayData.Period.aveTransPeriod =mean(tradeListh(:,4)-tradeListh(:,3));

% 平均盈利周期
DisplayData.Period.aveWinPeriod = mean(tradeListh(winIndex,4)-tradeListh(winIndex,3));

% 平均亏损周期
DisplayData.Period.aveLossPeriod = mean(tradeListh(loseIndex,4)-tradeListh(loseIndex,3));
 
% 最大盈利（%)
DisplayData.Main.maxWinRet = max(tradeReturns);
 
% 最大亏损 （%）
DisplayData.Main.maxLoseRet = min(tradeReturns);
 
% 最大盈利除以总盈利
DisplayData.Main.maxWinDivideGrossWin=DisplayData.Main.maxWinRet/DisplayData.Main.grossWin;

% 最大亏损除以总亏损
DisplayData.Main.maxLoseDivideGrossLose=DisplayData.Main.maxLoseRet/DisplayData.Main.grossLose;

% 净利润除以毛损
DisplayData.Main.netGainDivideMaxLose=DisplayData.Main.netGain/DisplayData.Main.grossLose;

% 最大持续盈利次数
DisplayData.Main.maxConWinTime = maxConGainTime(tradeReturns);
 
% 最大持续亏损次数
DisplayData.Main.maxConLoseTime = maxConLossTime(tradeReturns);

% 扣除最大盈利后收益率,输入参数account是总资产变动情况
 DisplayData.Main.winRateExcMaxRet = gainRateExcMax(tradeListh(:,1));

% 扣除最大亏损后收益率,输入参数account是总资产变动情况
 DisplayData.Main.loseRateExcMaxRet = lossRateExcMax(tradeListh(:,1));
 
% 扣除前N%最大盈利后的收益率，如果缺省，为5%。
 DisplayData.Main.gainRateExcMaxNpercentRet =gainRateExcMaxNpercentRet(tradeListh(:,1));

% 扣除前N%最大亏损后的收益率 ，如果缺省，为5%。
 DisplayData.Main.loseRateExcMaxNpercentRet =loseRateExcMaxNpercentRet(tradeListh(:,1));
  
% 调整后毛利：
% 盈利交易总数减去其平方根，在乘以策略盈利交易的平均盈利。用于降低原本的利润，如果调整后值让能够交易该策略，则策略更优.参见MC的测试报告
 DisplayData.Main.adjustgrossWin = (DisplayData.Trading.gainNum-sqrt(DisplayData.Trading.gainNum))*DisplayData.Trading.avgGain;
 DisplayData.Main.adjustgrossLose =(DisplayData.Trading.lossNum-sqrt(DisplayData.Trading.lossNum))*DisplayData.Trading.avgLoss;
 DisplayData.Main.adjustnetprofit = DisplayData.Main.adjustgrossWin+DisplayData.Main.adjustgrossLose;
 
 
 %% output
 
%  disp('Saving to excel...')
%  write2excel('BackTestResult.xlsx',...
%              my_struct2cell(DisplayData.Main),'Main',...
%              my_struct2cell(DisplayData.Trading),'Trading',...
%              my_struct2cell(DisplayData.Period),'Period',...
%              my_struct2cell(DisplayData.StatisticalIndex),'StatisticalIndex',...
%              my_struct2cell(DisplayData.RiskIndex),'RiskIndex');
         
end