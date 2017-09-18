%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������������嵥�������ָ�ꡣ
% �����嵥�ӿ�Ϊ��
% input1��cell������һ���ǲ��������漰֤ȯ���루�ֽ�Ҳ��Ϊһ��֤ȯ����һ��Ϊ�ֽ𣩣�
% �ڶ��������ճ���֤ȯ����֤ȯ�ļ�ֵ��
%  ���磺         {'cash','000001.SZ','000002.SZ';100000,0,0}
% input2��matrix������һ��Ϊ���ڣ���ʼ�ͽ�ֹ���������Ƿ���֤ȯ�ɽ�����Ӧ����������
% ����Ϊ����֤ȯ�������ֽ�,�ڶ���Ϊ�ֽ�����Ӧ���ڵĳɽ�����
% ���磺734153	0                    0              0
%       734160	-100000         4332.755633        0
%       734167	94020.79723     -4332.755633       1
%       734177	-94020.79723	4360.890409        -1
%       734193	94674.93079     -4360.890409        0
%       734194	-94674.93079	4274.263241         0
%       734195	95957.20976 	-4274.263241        0
%       734230	0                    0              0
% input3��vector������ֵ��������input2����Ӧ���ڵĳ��ֽ����������֤ȯ�ĳɽ��ۡ���������
% �ɽ�����ȡ�������̼ۡ�
% ���磺21.43      11.43
%       23.08      11.82
%       21.7       12.31
%       21.56      11.93
%       21.71      12.13
%       22.15      12.58
%       22.45      11.48
%       23.43      12.43
% ���е������������Displaydata�Ľṹ���У���ͬfield����չ�ֵ���ͬ��ѡ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function  Displaydata = calc_data_display(input1,input2,input3,r13,Configure)
%% download data
startdate = datestr(input2(1,1),29); % ����������Input�����ղ�ͬ������������ģ�ʹ����������
enddate = datestr(input2(end,1),29); % �����ֹ����Input�н�ֹ�ղ�ͬ������������ģ�ʹ�����Ľ�ֹ��
% ֤ȯ����
secucode = input1(1,2:end);


% ��ʼ�յ���ֹ��֮���������Ȼ��
Date = (input2(1,1):input2(end,1))';
Day = datestr(Date,29);
% ��ʼ�յ���ֹ��֮������н�����
% tradingdate = DH_D_TR_MarketTradingday(1,startdate,enddate);

% ������������������
disp('�����������ݣ��������ĵȴ�...');
marketdata = cell(size(secucode,2),1);

if Configure.downloadmark ==1 
    % ������д��Cache
    writeintocache_backtest(secucode,startdate,enddate,Configure.Path_Backtest_Cache);
    % ��Cache�ж�ȡ��������
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

disp('����������ϣ����ڶ�ȡ���ݣ�...');
disp('���ڽ��м��㣡��ȴ�... ...');
%% Main
% �������֤ȯÿ�ճɽ�������������ÿ�����ʲ���ֵ
[Volume,Account] = calc_account(marketdata,input1,input2,input3);

% �������֤ȯ��������������������
[close_buy,close_sell] = calc_buysellmark(Volume);

Displaydata.Main.secucode = secucode;

Displaydata.Main.marketdata = marketdata;  % ����֤ȯ���̼����У������Main ��ͼ
Displaydata.Main.close_buy = close_buy;    % ����֤ȯ���������̼����У������Main ��ͼ
Displaydata.Main.close_sell = close_sell; % ����֤ȯ���������̼����У������Main ��ͼ

if  isfield(Configure,'benchmark')
    % ��ȡָ�������Ȩ��
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

returns=diff(Account)./Account(1:end-1);  %ÿ��������ʣ��������մ��������ʣ���Ϊ���ս��׳ɽ���δ��Ϊ�������̼�
accum_returns=cumprod(returns+1); % �ۼ�������



Asset_v = cell2mat(input1(2,:));
Asset_v = cumsum([Asset_v;input2(:,2:end)]);
Asset_v = Asset_v(2:end,:);

price = input3;

[Displaydata.Main.wintradetime,Displaydata.Main.losetradetime,Displaydata.Main.totaltradetime,Displaydata.Main.win_averet,...
    Displaydata.Main.lose_averet,Displaydata.Main.winratio1,Displaydata.Main.winratio2] = calc_winloseratio(input2,Asset_v,price,Configure.benchmark,Configure.downloadmark);
%�����Main ��ͼ1��2
% ����������������ͬ��ҵ����׼������
Displaydata.Main.accumreturn = accum_returns(end)-1;  %�����Main ��ͼ3

if  isfield(Configure,'benchmark')
    % ��ȡָ�������Ȩ��
    [IndexCode,weight] = readindexcode(Configure.benchmark);
    Indexreturn =zeros(1,size(IndexCode,1));
    for Index =1:size(IndexCode,1)
        Indexreturn(1,Index) = F_ANALYSIS_INDEXRETURN(IndexCode{Index},startdate,enddate);
    end
    Displaydata.Main.benchmark = Indexreturn * weight; %�����Main ��ͼ3
end


%% Equity
% �����ۼ����������к���������������
Displaydata.Equity.accum_returns = [Date(1)-1,1;Date,accum_returns];                           % �����Equity ��ͼ
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
Displaydata.Equity.interval_returns_d = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark); % �����Equity ��ͼ
Displaydata.Equity.interval_returns_w = calc_series_returns(Account,startdate,enddate,2,Configure.downloadmark); % �����Equity ��ͼ
Displaydata.Equity.interval_returns_m = calc_series_returns(Account,startdate,enddate,3,Configure.downloadmark); % �����Equity ��ͼ
Displaydata.Equity.interval_returns_q = calc_series_returns(Account,startdate,enddate,4,Configure.downloadmark); % �����Equity ��ͼ
Displaydata.Equity.interval_returns_h = calc_series_returns(Account,startdate,enddate,5,Configure.downloadmark); % �����Equity ��ͼ
Displaydata.Equity.interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark); % �����Equity ��ͼ
% ��ӯ���������ܿ�������
Displaydata.Equity.win_day = size(returns(returns>0),1);   % �����Equity ��ͼ1
Displaydata.Equity.lose_day = size(returns(returns<0),1);  % �����Equity ��ͼ1
% �������ӯ�����������������������
Displaydata.Equity.maxConwl = CalculatemaxConSGN(returns) ;% �����Equity ��ͼ2
%% Buysellpoint
%  �����嵥
Displaydata.Buysellpoint.data = calc_buysellpoint(input1,input2,input3,Account,Date);  % �����BuySellPoint ����
%%  StatisticalIndex
% ���س������س��� ���س������Լ����Ƕ�Ӧ��ʱ��
[Displaydata.StatisticalIndex.drawdownratio,ddr_index,Displaydata.StatisticalIndex.drawdown,dd_index,Displaydata.StatisticalIndex.drawdownduration,ddd_index]=calculateMaxDD(returns);  % �����Equity ��ͼ3
Displaydata.Equity.drawdown = Displaydata.StatisticalIndex.drawdown;
Displaydata.StatisticalIndex.drawdown_time = datestr(Date(dd_index),29);
Displaydata.StatisticalIndex.drawdownratio_time = datestr(Date(ddr_index),29);
Displaydata.StatisticalIndex.drawdownduration_time = datestr(Date(ddd_index),29);



% ������ʼ�պͽ�ֹ��֮�����Ȼ�պͽ�����
tradingdate = DH_D_TR_MarketTradingday(1,startdate,enddate);
Displaydata.StatisticalIndex.testday(1) = datenum(enddate) - datenum(startdate) + 1;
Displaydata.StatisticalIndex.testday(2) = size(tradingdate,1);
% ��ʼ�ʲ���ֵ�������ʲ���ֵ
Displaydata.StatisticalIndex.initAsset = Account(1,1);
Displaydata.StatisticalIndex.enddateAsset = Account(end,1);

[Displaydata.StatisticalIndex.Coefficientofvariance,Displaydata.StatisticalIndex.Standarddeviation] = CalcCoefficientofvariance (Account);

% �������������У�ǰ������δ�޳����������ڣ������޳���
interval_returns_d = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
interval_returns_w = calc_series_returns(Account,startdate,enddate,2,Configure.downloadmark,2,2);
interval_returns_m = calc_series_returns(Account,startdate,enddate,3,Configure.downloadmark,2,2);
interval_returns_q = calc_series_returns(Account,startdate,enddate,4,Configure.downloadmark,2,2);
interval_returns_h = calc_series_returns(Account,startdate,enddate,5,Configure.downloadmark,2,2);
interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark,2,2);
% ���������ʾ�ֵ�Ͳ�����
Displaydata.StatisticalIndex.interval_returns_d_m = mean(interval_returns_d(:,2));
Displaydata.StatisticalIndex.interval_returns_d_s = std(interval_returns_d(:,2));
Displaydata.StatisticalIndex.interval_returns_d_kur = kurtosis(interval_returns_d(:,2));  % ��� ����3����̬�ֲ�Ҫ���ͣ�С��3����̬�ֲ�Ҫƽ̹
Displaydata.StatisticalIndex.interval_returns_d_ske = skewness(interval_returns_d(:,2));  % ƫ�� С��0��ƫ̬������0��ƫ̬


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
    % �����RiskIndex ��Ч�����ͷ���ָ��
    a = str2double(Configure.vara);
    varmethod = str2double(Configure.varmethod);
    rf = str2double(Configure.riskfreebench);
    
    %     ����VaR Ŀǰֻ�з���Э��������෽���´���������
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
% %tradeAccount �������ʲ�
% %tradeReturns ��������������
% tradeTime = input2(:,1);%��������
% tradeTimeTemp = tradeTime(2:end);
% tradeTimeGain = datestr( tradeTimeTemp(tradeReturns>0),29); %ӯ������ʱ��
% tradeTimeLoss = datestr( tradeTimeTemp(tradeReturns<0),29); %������ʱ��
% %��ӯ��
% Displaydata.Main.grossWin = sum(tradeReturns(tradeReturns>0));
% %�ܿ���
% Displaydata.Main.grossLose = sum(tradeReturns(tradeReturns<0));
% %��ӯ����ƽ��ӯ��
% Displaydata.StatisticalIndex.grossWinLose = sum(tradeReturns);
% Displaydata.StatisticalIndex.avgWinLose = Displaydata.StatisticalIndex.grossWinLose/length(tradeTime);
% %������
% Displaydata.StatisticalIndex.netGain = tradeAccount(end)-tradeAccount(1);
% %ƽ��ӯ������ƽ������
% AARate = aDivideA(Displaydata.StatisticalIndex.avgWinLose,Displaydata.Main.lose_averet);
% Displaydata.StatisticalIndex.aveWinDivedeAveLose = AARate;
% %ƽ��ӯ���������س�
% aveGainDevideMaxDDRet = aveGainDevideMaxMD(Displaydata.Main.win_averet,Displaydata.StatisticalIndex.drawdown);
% Displaydata.StatisticalIndex.aveWinDevideMaxDD = aveGainDevideMaxDDRet;
% %ƽ��ӯ������ƽ������
% aveGainDevideAveLossRet = aveGainDevideAveLoss(Displaydata.Main.win_averet,Displaydata.Main.lose_averet);
% Displaydata.StatisticalIndex.aveWinDevideAveLoss = aveGainDevideAveLossRet;
% %��ӯ�������ܿ���
% groGainDevideGroLossRet = groGainDevideGroLoss(Displaydata.Main.grossWin,Displaydata.Main.grossLose);
% Displaydata.StatisticalIndex.groWinDevideGroLoss = groGainDevideGroLossRet;
% %ӯ������
% Displaydata.StatisticalIndex.winRate = length(tradeTime(tradeReturns>0))/length(tradeTime);
% %�������
% Displaydata.StatisticalIndex.loseRate = length(tradeTime(tradeReturns<0))/length(tradeTime);
% %ƽ����������,�������R�ǽ���ʱ��
% aveTransPeriodRet = aveTransPeriod(tradeTime);
% Displaydata.StatisticalIndex.aveTransPeriod = aveTransPeriodRet;
% %ƽ��ӯ������
% aveGainPeriodRet = aveGainPeriod(tradeTimeGain);
% Displaydata.StatisticalIndex.aveWinPeriod = aveGainPeriodRet;
% %ƽ����������
% aveLossPeriodRet = aveLossPeriod(tradeTimeLoss);
% Displaydata.StatisticalIndex.aveLossPeriod = aveLossPeriodRet;
% %���ӯ��
% Displaydata.StatisticalIndex.maxWinRet = max(tradeReturns(tradeReturns>0));
% %������
% Displaydata.StatisticalIndex.maxLoseRet = max(tradeReturns(tradeReturns<0));
% %���ӯ��������ӯ��
% maxDevideGGRet = maxDevideGG(Displaydata.StatisticalIndex.maxWinRet,Displaydata.Main.grossWin);
% Displaydata.StatisticalIndex.maxWinDevideGrossWin = maxDevideGGRet;
% %����������ܿ���
% maxDevideGLRet = maxDevideGL(Displaydata.StatisticalIndex.maxLoseRet,Displaydata.Main.grossLose);
% Displaydata.StatisticalIndex.maxLoseDevideGrossLose = maxDevideGLRet;
% %���������������
% netGainDevideMaxLossRet = netGainDevideMaxLoss(Displaydata.StatisticalIndex.netGain,Displaydata.Main.grossLose);
% Displaydata.StatisticalIndex.netGainDevideMaxLose = netGainDevideMaxLossRet;
% %������ӯ������
% maxConGainTimeRet = maxConGainTime(tradeReturns);
% Displaydata.StatisticalIndex.maxConWinTime = maxConGainTimeRet;
% %�������������
% maxConLossTimeRet = maxConLossTime(tradeReturns);
% Displaydata.StatisticalIndex.maxConLoseTime = maxConLossTimeRet;
% %���ʹ���ʽ�
% maxUsedFundRet = max(sum(input2(:,3:end).*input3),2);
% Displaydata.StatisticalIndex.maxUsedFund = maxUsedFundRet;
% %�۳����ӯ����������,�������Account�����ʲ��䶯���
% gainRateExcMaxRet = gainRateExcMax(tradeAccount);
% Displaydata.StatisticalIndex.winRateExcMaxRet = gainRateExcMaxRet;
% %�۳��������������,�������Account�����ʲ��䶯���
% lossRateExcMaxRet = lossRateExcMax(tradeAccount);
% Displaydata.StatisticalIndex.loseRateExcMaxRet = lossRateExcMaxRet;
% %�ڼ����Ȩ��
% maxGainInPeriodRet = maxGainInPeriod(tradeAccount);
% Displaydata.StatisticalIndex.maxWinInPeriodRet = maxGainInPeriodRet;
% %�ڼ���СȨ��
% minGainInPeriodRet = minGainInPeriod(tradeAccount);
% Displaydata.StatisticalIndex.minWinInPeriodRet = minGainInPeriodRet;
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ϊ���ܵ��õ��ĺ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% % ƽ��ӯ���ܳ���ƽ������
%     function AARate = aDivideA(aveGrossGLRet,aveLoss)
%         AARate = aveGrossGLRet/aveLoss;
%     end
%
% % ���س������س�ʱ���������ļ����еĺ���MD��Ķ�
%
% % ƽ��ӯ���������س�
%     function aveGainDevideMaxMDRet = aveGainDevideMaxMD(aveGain,maxMD)
%         aveGainDevideMaxMDRet = aveGain/maxMD;
%     end
% % ƽ��ӯ������ƽ������
%     function aveGainDevideAveLossRet = aveGainDevideAveLoss(aveGain,aveLoss)
%         aveGainDevideAveLossRet = aveGain/aveLoss;
%     end
% % ��ӯ�������ܿ���
%     function groGainDevideGroLossRet = groGainDevideGroLoss(groGain,groLoss)
%         groGainDevideGroLossRet = groGain/groLoss;
%     end
% % ƽ����������,�������R�ǽ���ʱ��
%     function aveTransPeriodRet = aveTransPeriod(R)
%         aveTransPeriodRet = mean(diff(datenum(R)));
%     end
% % ƽ��ӯ�����ڣ��������Rg��ӯ���Ľ���ʱ��
%     function aveGainPeriodRet = aveGainPeriod(Rg)
%         aveGainPeriodRet = mean(diff(datenum(Rg)));
%     end
% % ƽ���������ڣ��������Rl��ӯ���Ľ���ʱ��
%     function aveLossPeriodRet = aveLossPeriod(Rl)
%         aveLossPeriodRet = mean(diff(datenum(Rl)));
%     end
% % ���ӯ��������ӯ��
%     function maxDevideGGRet = maxDevideGG(maxGain,grossGain)
%         maxDevideGGRet = maxGain/grossGain;
%     end
% % �����������ӯ��
%     function maxDevideGLRet = maxDevideGL(maxLoss,grossLoss)
%         maxDevideGLRet = maxLoss/grossLoss;
%     end
% % ���������������
%     function netGainDevideMaxLossRet = netGainDevideMaxLoss(netGain,maxLoss)
%         netGainDevideMaxLossRet = netGain/maxLoss;
%     end
% % ������ӯ������,�������R�ǽ���ӯ�����
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
% % ����������������������R�ǽ���ӯ�����
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
% % �۳����ӯ����������,�������Account�����ʲ��䶯���
%     function gainRateExcMaxRet = gainRateExcMax(Account)
%         returnRate=diff(Account)./Account(1:end-1);
%         [C,I] = max(returnRate);
%         returnRate(I) = [];
%         gainRateExcMaxRet = prod(returnRate+1)-1;
%     end
% % �۳��������������,�������Account�����ʲ��䶯���
%     function lossRateExcMaxRet = lossRateExcMax(Account)
%         returnRate=diff(Account)./Account(1:end-1);
%         [C,I] = max(returnRate);
%         returnRate(I) = [];
%         lossRateExcMaxRet = prod(returnRate+1)-1;
%     end
% % �ڼ����Ȩ��
%     function maxGainInPeriodRet = maxGainInPeriod(Account)
%         maxGainInPeriodRet = max(Account);
%     end
% % �ڼ���СȨ��
%     function minGainInPeriodRet = minGainInPeriod(Account)
%         minGainInPeriodRet = min(Account);
%     end
 end