%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数运用买卖清单计算各类指标。
% 买卖清单接口为：
% input1（cell），第一行是策略中所涉及证券代码（现金也作为一种证券，第一列为现金），
% 第二行是首日持有证券各种证券的价值。
%  例如：         {'cash','000001.SZ','000002.SZ';100000,0,0}
% input2（matrix），第一列为日期（起始和截止日期无论是否有证券成交，都应当包含），
% 后面为各种证券（包括现金,第二列为现金）在相应日期的成交量。
% 例如：734153	0                    0              0
%       734160	-100000         4332.755633        0
%       734167	94020.79723     -4332.755633       1
%       734177	-94020.79723	4360.890409        -1
%       734193	94674.93079     -4360.890409        0
%       734194	-94674.93079	4274.263241         0
%       734195	95957.20976 	-4274.263241        0
%       734230	0                    0              0
% input3（vector），数值型向量，input2中相应日期的除现金以外的其它证券的成交价。若当天无
% 成交，则取当天收盘价。
% 例如：21.43      11.43
%       23.08      11.82
%       21.7       12.31
%       21.56      11.93
%       21.71      12.13
%       22.15      12.58
%       22.45      11.48
%       23.43      12.43
% 所有的输出均保存在Displaydata的结构体中，不同field数据展现到不同的选项卡中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function  Displaydata = calc_data_display(input1,input2,input3,r13,Configure)
%% download data
startdate = datestr(input2(1,1),29); % 这里首日与Input中首日不同，这里首日是模型处理后的首日
enddate = datestr(input2(end,1),29); % 这里截止日与Input中截止日不同，这里首日是模型处理后的截止日
% 证券代码
secucode = input1(1,2:end);


% 起始日到截止日之间的所有自然日
Date = (input2(1,1):input2(end,1))';
Day = datestr(Date,29);
% 起始日到截止日之间的所有交易日
% tradingdate = DH_D_TR_MarketTradingday(1,startdate,enddate);

% 下载所需日行情数据
disp('正在下载数据！请您耐心等待...');
marketdata = cell(size(secucode,2),1);

if Configure.downloadmark ==1 
    % 将数据写入Cache
    writeintocache_backtest(secucode,startdate,enddate,Configure.Path_Backtest_Cache);
    % 从Cache中读取所需数据
    for Index = 1:size(secucode,2)
        SecuCode = secucode{1,Index};
        marketdata{Index} = readfromcache_backtest(SecuCode,startdate,enddate,Configure.Path_Backtest_Cache);
    end
else
    for Index = 1:size(secucode,2)
        SecuCode = secucode{1,Index};
        open_3 = DH_Q_DQ_Stock(SecuCode,Day,'Open',3);
        high_3 = DH_Q_DQ_Stock(SecuCode,Day,'High',3);
        low_3 = DH_Q_DQ_Stock(SecuCode,Day,'Low',3);
        volume = DH_Q_DQ_Stock(SecuCode,Day,'Volume',3);
        close_1 = DH_Q_DQ_Stock(SecuCode,Day,'Close',1);
        close_2 = DH_Q_DQ_Stock(SecuCode,Day,'Close',2);
        close_3 = DH_Q_DQ_Stock(SecuCode,Day,'Close',3);
        Temp_Data = [Date,open_3,high_3,low_3,close_3,volume,close_1,close_2];
        marketdata{Index} = Temp_Data ;
    end
end

disp('下载数据完毕！正在读取数据！...');
disp('正在进行计算！请等待... ...');
%% Main
% 计算各种证券每日成交量，持有量和每日总资产价值
[Volume,Account] = calc_account(marketdata,input1,input2,input3);

% 计算各种证券买入或者卖出天数的序号
[close_buy,close_sell] = calc_buysellmark(Volume);

Displaydata.Main.secucode = secucode;

Displaydata.Main.marketdata = marketdata;  % 各个证券收盘价序列，输出到Main 主图
Displaydata.Main.close_buy = close_buy;    % 各个证券购买日收盘价序列，输出到Main 主图
Displaydata.Main.close_sell = close_sell; % 各个证券出售日收盘价序列，输出到Main 主图

if  isfield(Configure,'benchmark')
    % 读取指数代码和权重
    [IndexCode,weight] = readindexcode(Configure.benchmark);
    benchmarkprice = zeros(size(Date,1),size(IndexCode,1));
    for Index =1:size(IndexCode,1)
        if Configure.downloadmark ==0
            Temp = DH_Q_DQ_Index(IndexCode{Index},Day,'Close');
        else
            Temp = readfromcache_backtest(IndexCode{Index},startdate,enddate,Configure.Path_Backtest_Cache);
            Temp = Temp(:,5)';
        end
        
        benchmarkprice(:,Index) = Temp';
    end
    Displaydata.Main.benchmarkprice = benchmarkprice * weight;
    
    Displaydata.Main.benchmarkprice =[Date,Displaydata.Main.benchmarkprice];
end

returns=diff(Account)./Account(1:end-1);  %每天的收益率，这里首日存在收益率，因为首日交易成交价未必为该日收盘价
accum_returns=cumprod(returns+1); % 累计收益率



Asset_v = cell2mat(input1(2,:));
Asset_v = cumsum([Asset_v;input2(:,2:end)]);
Asset_v = Asset_v(2:end,:);

price = input3;

[Displaydata.Main.wintradetime,Displaydata.Main.losetradetime,Displaydata.Main.totaltradetime,Displaydata.Main.win_averet,...
    Displaydata.Main.lose_averet,Displaydata.Main.winratio1,Displaydata.Main.winratio2] = calc_winloseratio(input2,Asset_v,price,Configure.benchmark,Configure.downloadmark);
%输出到Main 右图1和2
% 计算最终收益率与同期业绩基准收益率
Displaydata.Main.accumreturn = accum_returns(end)-1;  %输出到Main 右图3

if  isfield(Configure,'benchmark')
    % 读取指数代码和权重
    [IndexCode,weight] = readindexcode(Configure.benchmark);
    Indexreturn =zeros(1,size(IndexCode,1));
    for Index =1:size(IndexCode,1)
        Indexreturn(1,Index) = F_ANALYSIS_INDEXRETURN(IndexCode{Index},startdate,enddate);
    end
    Displaydata.Main.benchmark = Indexreturn * weight; %输出到Main 右图3
end


%% Equity
% 计算累计收益率序列和区间收益率序列
Displaydata.Equity.accum_returns = [Date(1)-1,1;Date,accum_returns];                           % 输出到Equity 主图
if  isfield(Configure,'benchmark')
    [IndexCode,weight] = readindexcode(Configure.benchmark);
    Temp = F_SERIES_INDEXRETURN(IndexCode{1},startdate,enddate,1,1,1);
    Indexreturn2 = ones(size(Temp,1),size(IndexCode,1));
    for Index =1:size(IndexCode,1)
        Temp = F_SERIES_INDEXRETURN(IndexCode{Index},startdate,enddate,1,1,1);
        Loc =cellfun(@isempty,Temp(:,2));
        Temp(Loc,2) = {0};
        Temp = cell2mat(Temp(:,2));
        Indexreturn2(:,Index) = Temp;
    end
    IR = Indexreturn2* weight;
    Displaydata.Equity.IR_acc = [Date(1)-1,1;Date,cumprod(IR+1)];
end
Displaydata.Equity.interval_returns_d = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark); % 输出到Equity 主图
Displaydata.Equity.interval_returns_w = calc_series_returns(Account,startdate,enddate,2,Configure.downloadmark); % 输出到Equity 主图
Displaydata.Equity.interval_returns_m = calc_series_returns(Account,startdate,enddate,3,Configure.downloadmark); % 输出到Equity 主图
Displaydata.Equity.interval_returns_q = calc_series_returns(Account,startdate,enddate,4,Configure.downloadmark); % 输出到Equity 主图
Displaydata.Equity.interval_returns_h = calc_series_returns(Account,startdate,enddate,5,Configure.downloadmark); % 输出到Equity 主图
Displaydata.Equity.interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark); % 输出到Equity 主图
% 总盈利天数与总亏损天数
Displaydata.Equity.win_day = size(returns(returns>0),1);   % 输出到Equity 右图1
Displaydata.Equity.lose_day = size(returns(returns<0),1);  % 输出到Equity 右图1
% 最大连续盈利天数与最大连续亏损天数
Displaydata.Equity.maxConwl = CalculatemaxConSGN(returns) ;% 输出到Equity 右图2
%% Buysellpoint
%  买卖清单
Displaydata.Buysellpoint.data = calc_buysellpoint(input1,input2,input3,Account,Date);  % 输出到BuySellPoint 主表
%%  StatisticalIndex
% 最大回撤、最大回撤比 最大回撤周期以及它们对应的时间
[Displaydata.StatisticalIndex.drawdownratio,ddr_index,Displaydata.StatisticalIndex.drawdown,dd_index,Displaydata.StatisticalIndex.drawdownduration,ddd_index]=calculateMaxDD(returns);  % 输出到Equity 右图3
Displaydata.Equity.drawdown = Displaydata.StatisticalIndex.drawdown;
Displaydata.StatisticalIndex.drawdown_time = datestr(Date(dd_index),29);
Displaydata.StatisticalIndex.drawdownratio_time = datestr(Date(ddr_index),29);
Displaydata.StatisticalIndex.drawdownduration_time = datestr(Date(ddd_index),29);



% 计算起始日和截止日之间的自然日和交易日
tradingdate = DH_D_TR_MarketTradingday(1,startdate,enddate);
Displaydata.StatisticalIndex.testday(1) = datenum(enddate) - datenum(startdate) + 1;
Displaydata.StatisticalIndex.testday(2) = size(tradingdate,1);
% 初始资产总值和最终资产总值
Displaydata.StatisticalIndex.initAsset = Account(1,1);
Displaydata.StatisticalIndex.enddateAsset = Account(end,1);

[Displaydata.StatisticalIndex.Coefficientofvariance,Displaydata.StatisticalIndex.Standarddeviation] = CalcCoefficientofvariance (Account);

% 区间收益率序列（前面收益未剔除不完整周期，这里剔除）
interval_returns_d = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
interval_returns_w = calc_series_returns(Account,startdate,enddate,2,Configure.downloadmark,2,2);
interval_returns_m = calc_series_returns(Account,startdate,enddate,3,Configure.downloadmark,2,2);
interval_returns_q = calc_series_returns(Account,startdate,enddate,4,Configure.downloadmark,2,2);
interval_returns_h = calc_series_returns(Account,startdate,enddate,5,Configure.downloadmark,2,2);
interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark,2,2);
% 区间收益率均值和波动率
Displaydata.StatisticalIndex.interval_returns_d_m = mean(interval_returns_d(:,2));
Displaydata.StatisticalIndex.interval_returns_d_s = std(interval_returns_d(:,2));
Displaydata.StatisticalIndex.interval_returns_d_kur = kurtosis(interval_returns_d(:,2));  % 峰度 大于3比正态分布要陡峭，小于3比正态分布要平坦
Displaydata.StatisticalIndex.interval_returns_d_ske = skewness(interval_returns_d(:,2));  % 偏度 小于0左偏态，大于0右偏态


Displaydata.StatisticalIndex.interval_returns_w_m = mean(interval_returns_w(:,2));
Displaydata.StatisticalIndex.interval_returns_w_s = std(interval_returns_w(:,2));
Displaydata.StatisticalIndex.interval_returns_m_m = mean(interval_returns_m(:,2));
Displaydata.StatisticalIndex.interval_returns_m_s = std(interval_returns_m(:,2));
Displaydata.StatisticalIndex.interval_returns_q_m = mean(interval_returns_q(:,2));
Displaydata.StatisticalIndex.interval_returns_q_s = std(interval_returns_q(:,2));
Displaydata.StatisticalIndex.interval_returns_h_m = mean(interval_returns_h(:,2));
Displaydata.StatisticalIndex.interval_returns_h_s = std(interval_returns_h(:,2));
Displaydata.StatisticalIndex.interval_returns_y_m = mean(interval_returns_y(:,2));
Displaydata.StatisticalIndex.interval_returns_y_s = std(interval_returns_y(:,2));
Displaydata.StatisticalIndex.TotalReturn = Displaydata.Main.accumreturn;



R = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
R = R(:,2);
Displaydata.StatisticalIndex.std = std(R);

%%  RiskIndex
if r13 ==1
    % 输出到RiskIndex 绩效评估和风险指标
    a = str2double(Configure.vara);
    varmethod = str2double(Configure.varmethod);
    rf = str2double(Configure.riskfreebench);
    
    %     计算VaR 目前只有方差协方差法，其余方法下次升级加入
    switch varmethod
        case 1
            Displaydata.RiskIndex.VaR = portvrisk(mean(R),std(R),a);
        case 2
        case 3
        case 4
        otherwise
    end
    
    if rf == -1
        Rf = F_SERIES_RISKFREERETURN(startdate,enddate,1,2,1);
        Rf = cell2mat(Rf(:,2));
        Rf = Rf(2:end);
    else
        Rf = rf/365;
        Rf = Rf*ones(size(R,1),1);
    end
    Rm = F_SERIES_INDEXRETURN(Configure.marketbench,startdate,enddate,1,2,1);
    Rm = cell2mat(Rm(:,2));
    Rm = Rm(2:end);
    if  isfield(Configure,'benchmark')
        [IndexCode,weight] = readindexcode(Configure.benchmark);
        Temp = F_SERIES_INDEXRETURN(IndexCode{1},startdate,enddate,1,2,1);
        Indexreturn2 = nan(size(Temp,1),size(IndexCode,1));
        for Index =1:size(IndexCode,1)
            Temp = F_SERIES_INDEXRETURN(IndexCode{Index},startdate,enddate,1,2,1);
            Temp = cell2mat(Temp(:,2));
            Indexreturn2(:,Index) = Temp;
        end
        IR = Indexreturn2* weight;
        IR = IR(2:end);
        
        Displaydata.RiskIndex.trackingerror = annualizetrackingerror(R,IR,1);
        Displaydata.RiskIndex.InformationRatio= mean(R-IR)/std(R-IR);
    else
        Displaydata.RiskIndex.trackingerror = nan;
        Displaydata.RiskIndex.InformationRatio = nan;
    end
    
    Displaydata.RiskIndex.TotalReturn = Displaydata.Main.accumreturn;
    Displaydata.RiskIndex.annstd =annualizestdev(R,1);
    Displaydata.RiskIndex.sharperatio = SharpeRatio( R,Rf);
    Displaydata.RiskIndex.Beta =betaCoefficient( R,Rm);
    Displaydata.RiskIndex.Alpha =alphaCoefficient( R,Rm,Rf,Displaydata.RiskIndex.Beta);
    Displaydata.RiskIndex.Treynor = treynorCoefficient( R,Rf,Displaydata.RiskIndex.Beta);
    Displaydata.RiskIndex.omegaC = omegaCoefficient( R,Rf);
    Displaydata.RiskIndex.SoRa = sortinoRatio( R,Rf );
    Displaydata.RiskIndex.calmarR = calmarRatio( R,Rf);
    Displaydata.RiskIndex.kappaC = kappa3(R,Rf);
    Displaydata.RiskIndex.sterlingR = sterlingRatio( R,Rf);
    Displaydata.RiskIndex.burkeR = burkeRatio( R,Rf );
    Displaydata.RiskIndex.conditionalSharpeR = conditionalSharpe( R,Rf,Displaydata.RiskIndex.VaR);
    Displaydata.RiskIndex.modifiedSharpeR = modifiedSharpe( R,Rf,Displaydata.RiskIndex.VaR );
    Displaydata.RiskIndex.exRetVaR = excessReturnOnVaR( R,Rf,Displaydata.RiskIndex.VaR);
end

% %% backup Index
% %tradeAccount 交易总资产
% %tradeReturns 交易收益率序列
% tradeTime = input2(:,1);%交易日期
% tradeTimeTemp = tradeTime(2:end);
% tradeTimeGain = datestr( tradeTimeTemp(tradeReturns>0),29); %盈利交易时间
% tradeTimeLoss = datestr( tradeTimeTemp(tradeReturns<0),29); %亏损交易时间
% %总盈利
% Displaydata.Main.grossWin = sum(tradeReturns(tradeReturns>0));
% %总亏损
% Displaydata.Main.grossLose = sum(tradeReturns(tradeReturns<0));
% %总盈亏，平均盈亏
% Displaydata.StatisticalIndex.grossWinLose = sum(tradeReturns);
% Displaydata.StatisticalIndex.avgWinLose = Displaydata.StatisticalIndex.grossWinLose/length(tradeTime);
% %净利润
% Displaydata.StatisticalIndex.netGain = tradeAccount(end)-tradeAccount(1);
% %平均盈亏除以平均亏损
% AARate = aDivideA(Displaydata.StatisticalIndex.avgWinLose,Displaydata.Main.lose_averet);
% Displaydata.StatisticalIndex.aveWinDivedeAveLose = AARate;
% %平均盈利除以最大回撤
% aveGainDevideMaxDDRet = aveGainDevideMaxMD(Displaydata.Main.win_averet,Displaydata.StatisticalIndex.drawdown);
% Displaydata.StatisticalIndex.aveWinDevideMaxDD = aveGainDevideMaxDDRet;
% %平均盈利除以平均亏损
% aveGainDevideAveLossRet = aveGainDevideAveLoss(Displaydata.Main.win_averet,Displaydata.Main.lose_averet);
% Displaydata.StatisticalIndex.aveWinDevideAveLoss = aveGainDevideAveLossRet;
% %总盈利除以总亏损
% groGainDevideGroLossRet = groGainDevideGroLoss(Displaydata.Main.grossWin,Displaydata.Main.grossLose);
% Displaydata.StatisticalIndex.groWinDevideGroLoss = groGainDevideGroLossRet;
% %盈利比率
% Displaydata.StatisticalIndex.winRate = length(tradeTime(tradeReturns>0))/length(tradeTime);
% %亏损比率
% Displaydata.StatisticalIndex.loseRate = length(tradeTime(tradeReturns<0))/length(tradeTime);
% %平均交易周期,输入参数R是交易时间
% aveTransPeriodRet = aveTransPeriod(tradeTime);
% Displaydata.StatisticalIndex.aveTransPeriod = aveTransPeriodRet;
% %平均盈利周期
% aveGainPeriodRet = aveGainPeriod(tradeTimeGain);
% Displaydata.StatisticalIndex.aveWinPeriod = aveGainPeriodRet;
% %平均亏损周期
% aveLossPeriodRet = aveLossPeriod(tradeTimeLoss);
% Displaydata.StatisticalIndex.aveLossPeriod = aveLossPeriodRet;
% %最大盈利
% Displaydata.StatisticalIndex.maxWinRet = max(tradeReturns(tradeReturns>0));
% %最大亏损
% Displaydata.StatisticalIndex.maxLoseRet = max(tradeReturns(tradeReturns<0));
% %最大盈利除以总盈利
% maxDevideGGRet = maxDevideGG(Displaydata.StatisticalIndex.maxWinRet,Displaydata.Main.grossWin);
% Displaydata.StatisticalIndex.maxWinDevideGrossWin = maxDevideGGRet;
% %最大亏损除以总亏损
% maxDevideGLRet = maxDevideGL(Displaydata.StatisticalIndex.maxLoseRet,Displaydata.Main.grossLose);
% Displaydata.StatisticalIndex.maxLoseDevideGrossLose = maxDevideGLRet;
% %净利润除以最大亏损
% netGainDevideMaxLossRet = netGainDevideMaxLoss(Displaydata.StatisticalIndex.netGain,Displaydata.Main.grossLose);
% Displaydata.StatisticalIndex.netGainDevideMaxLose = netGainDevideMaxLossRet;
% %最大持续盈利次数
% maxConGainTimeRet = maxConGainTime(tradeReturns);
% Displaydata.StatisticalIndex.maxConWinTime = maxConGainTimeRet;
% %最大持续亏损次数
% maxConLossTimeRet = maxConLossTime(tradeReturns);
% Displaydata.StatisticalIndex.maxConLoseTime = maxConLossTimeRet;
% %最大使用资金
% maxUsedFundRet = max(sum(input2(:,3:end).*input3),2);
% Displaydata.StatisticalIndex.maxUsedFund = maxUsedFundRet;
% %扣除最大盈利后收益率,输入参数Account是总资产变动情况
% gainRateExcMaxRet = gainRateExcMax(tradeAccount);
% Displaydata.StatisticalIndex.winRateExcMaxRet = gainRateExcMaxRet;
% %扣除最大亏损后收益率,输入参数Account是总资产变动情况
% lossRateExcMaxRet = lossRateExcMax(tradeAccount);
% Displaydata.StatisticalIndex.loseRateExcMaxRet = lossRateExcMaxRet;
% %期间最大权益
% maxGainInPeriodRet = maxGainInPeriod(tradeAccount);
% Displaydata.StatisticalIndex.maxWinInPeriodRet = maxGainInPeriodRet;
% %期间最小权益
% minGainInPeriodRet = minGainInPeriod(tradeAccount);
% Displaydata.StatisticalIndex.minWinInPeriodRet = minGainInPeriodRet;
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以下为可能调用到的函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% % 平均盈亏总除以平均亏损
%     function AARate = aDivideA(aveGrossGLRet,aveLoss)
%         AARate = aveGrossGLRet/aveLoss;
%     end
%
% % 最大回撤和最大回撤时间在另外文件夹中的函数MD里改动
%
% % 平均盈利除以最大回撤
%     function aveGainDevideMaxMDRet = aveGainDevideMaxMD(aveGain,maxMD)
%         aveGainDevideMaxMDRet = aveGain/maxMD;
%     end
% % 平均盈利除以平均亏损
%     function aveGainDevideAveLossRet = aveGainDevideAveLoss(aveGain,aveLoss)
%         aveGainDevideAveLossRet = aveGain/aveLoss;
%     end
% % 总盈利除以总亏损
%     function groGainDevideGroLossRet = groGainDevideGroLoss(groGain,groLoss)
%         groGainDevideGroLossRet = groGain/groLoss;
%     end
% % 平均交易周期,输入参数R是交易时间
%     function aveTransPeriodRet = aveTransPeriod(R)
%         aveTransPeriodRet = mean(diff(datenum(R)));
%     end
% % 平均盈利周期，输入参数Rg是盈利的交易时间
%     function aveGainPeriodRet = aveGainPeriod(Rg)
%         aveGainPeriodRet = mean(diff(datenum(Rg)));
%     end
% % 平均亏损周期，输入参数Rl是盈利的交易时间
%     function aveLossPeriodRet = aveLossPeriod(Rl)
%         aveLossPeriodRet = mean(diff(datenum(Rl)));
%     end
% % 最大盈利除以总盈利
%     function maxDevideGGRet = maxDevideGG(maxGain,grossGain)
%         maxDevideGGRet = maxGain/grossGain;
%     end
% % 最大亏损除以总盈利
%     function maxDevideGLRet = maxDevideGL(maxLoss,grossLoss)
%         maxDevideGLRet = maxLoss/grossLoss;
%     end
% % 净利润除以最大亏损
%     function netGainDevideMaxLossRet = netGainDevideMaxLoss(netGain,maxLoss)
%         netGainDevideMaxLossRet = netGain/maxLoss;
%     end
% % 最大持续盈利次数,输入参数R是交易盈亏情况
%     function maxConGainTimeRet = maxConGainTime(R)
%         R(R>0) = 1;
%         if R(end) == 1
%             R = [R;-1];
%         end
%         indexMax = 0;
%         maxTemp = 0;
%         for i = 1:length(R)
%             if R(i) == 1
%                 maxTemp = maxTemp + 1;
%             else
%                 indexMax = indexMax + 1;
%                 maxGain(indexMax) = maxTemp;
%                 maxTemp = 0;
%             end
%         end
%         maxConGainTimeRet = max(maxGain);
%     end
% % 最大持续亏损次数，输入参数R是交易盈亏情况
%     function maxConLossTimeRet = maxConLossTime(R)
%         R(R<0) = -1;
%         if R(end) == -1
%             R = [R;1];
%         end
%         indexMax = 0;
%         maxTemp = 0;
%         for i = 1:length(R)
%             if R(i) == -1
%                 maxTemp = maxTemp + 1;
%             else
%                 indexMax = indexMax + 1;
%                 maxLoss(indexMax) = maxTemp;
%                 maxTemp = 0;
%             end
%         end
%         maxConLossTimeRet = max(maxLoss);
%     end
% % 扣除最大盈利后收益率,输入参数Account是总资产变动情况
%     function gainRateExcMaxRet = gainRateExcMax(Account)
%         returnRate=diff(Account)./Account(1:end-1);
%         [C,I] = max(returnRate);
%         returnRate(I) = [];
%         gainRateExcMaxRet = prod(returnRate+1)-1;
%     end
% % 扣除最大亏损后收益率,输入参数Account是总资产变动情况
%     function lossRateExcMaxRet = lossRateExcMax(Account)
%         returnRate=diff(Account)./Account(1:end-1);
%         [C,I] = max(returnRate);
%         returnRate(I) = [];
%         lossRateExcMaxRet = prod(returnRate+1)-1;
%     end
% % 期间最大权益
%     function maxGainInPeriodRet = maxGainInPeriod(Account)
%         maxGainInPeriodRet = max(Account);
%     end
% % 期间最小权益
%     function minGainInPeriodRet = minGainInPeriod(Account)
%         minGainInPeriodRet = min(Account);
%     end
 end
