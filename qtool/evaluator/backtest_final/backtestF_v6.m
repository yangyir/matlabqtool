function [DisplayData] = backtestF_v6(signal, bars, configure)
%% Backtest ���ݰٷֱȲ�λ�ź����۲������ڻ��г����֡�
% ����Ҫ����
% �ú�������6��ģ�飺
% 1. ���ļ��㣺��������������㾻ֵ����λ�������������ѵ�ʱ�����У��Լ������嵥��
%             ���¶��ǻ�����Щ�������ķ�����
% 2. �����˻���ֵ�ķ����������ʣ����س����ʽ�ռ���ʵ�ָ�ꡣ
% 3. ������Ƭ�����ʵķ�����ӯ��/������Ƭ��������ӯ��/������Ƭ������������ָ��ȡ�
% 4. �������������еķ���������Ƭ������ת��Ϊ�������ʣ�������ͳ�ơ�
% 5. ���ڽ����嵥�ķ�������һ�� ����-�ز� ���� �Ӳ�-���� ���̶���Ϊһ�������Ľ��ף�
%             �Խ������н���ͳ�Ʒ�����
% 6. �����������������浽mat�ļ���xlsx�ļ���
%
% �������������
% SIGNAL: �ٷֱȲ�λ�źţ�Ϊһ��N*1��ʱ�����С��ź�ֵӦ��[-1,1]�����ڡ�
%         �����ź�ֵ�ı䶯��ȷ����ʱ���Ƿ񷢳��µ�ָ�
%         ��������ź�ֵ�����ʱ�̵��µ������������ò���(configure.lag)���ɽ��ź�
%         ����ӳ١����磺
%         signal = [0,1,1,0,0], configure.lag = 2;
%         �ڶ���ʱ�������µ��źţ����ݴ˿̵ľ�ֵ���źź����̼۸�����Ŀ���λ��Ŀ���λ
%         �뵱ǰ��λ�Ĳ�ֵ��Ϊ�µ�������ֵΪ���¶൥����֮�յ����ź��ӳ���Ϊ2�������ָ��
%         �ڵ�4��ʱ����Կ��̼۳ɽ���
% 
% BARS��  ������Ƭ��Ϣ,Ϊһ��Bars��������Ӧ�ð���������high, low, close, open, vwap, time.
%         ����������ݰ����������飬��Ҫ������������������ÿ��ά��ֻ��һ�����������ӵ�ʱ������
%         ���ռ���Ծ���κε�����
%
% CONFIGURE�����ò�����Ϊһ���ṹ�壬����Ĭ��ֵ�Ĳ����⣬����������Ҫ��ֵ��
%         cost:        �����׳ɱ���Ϊ�ɱ�ռ���ױ�Ľ��ı���������Ӧ����Ӷ��
%                      Ҳ���ʵ��Ӵ��Է�Ӧ����ɱ���
%         leverage��   �ܸ��ʣ�һ��Ϊһ����[1,8]֮�����ֵ��Ϊ���׽������ڼƻ����
%                      �ķŴ��ʡ�
%         lag��        �ź��ӳٵ�λ��Ĭ��ֵΪ1,Ϊһ����������lag=N�����²����Ľ����źŽ���N��
%                      ʱ����Ƭ֮��ɽ����ź��ӳٵ�ȷ����Ҫ����ʵ�ʵĽ���ʱ����ȷ����
%         orderStyle:  �µ����Ĭ��ֵΪ0.
%                      orderStyle = 0������signal������Ľ������µ���
%                      orderStyle = 1, ����signal�жϽ��׷���ÿ��ֻ��1�֡�
%         initValue��  ��ʼ�˻���Ӧȫ��Ϊ�ֽ�
%         multiplier�� ��Լ������
%         marginRate�� �ڻ��������涨����ͱ�֤�������
%         riskfreebench�� 
%                      �껯�޷������ʡ�
%         varmethod��  ������ռ�ֵ�ķ�����Ŀǰֻ�ṩһ�ַ�����Ĭ��ֵΪ1��
%         vara��       ������ʧ�������ռ�ֵ�������ʡ�1-vara�Ƿ��ռ�ֵ������ˮƽ��
%                      Ĭ��ֵ0.05.
%         riskIndex��  �������ϵ���Ŀ��أ�Ĭ��ֵΪ1.
%                      riskIndex = 1���������ϵ����
%                      riskIndex = 0�����������ϵ����
%         min_open:    ��࿪������
%         max_open:    ��࿪������
%         safepos��    ��ͱ�֤�����
%     
% �������������
% ���е������������DisplayData�Ľṹ���У���Detail���⣬�������������뵽
% cd\res\BackTestResult.xlsx��ÿ������һ��worksheet.
% DisplayData�ṹ����:
% Main: ���Լ�Ч��Ҫ��
%     ��ֵ�ĳ�ʼֵ/���ֵ/���ֵ/����ֵ���ܽ��׷��ã��ʲ���ֵ����
%     ���س�(�ٷֱȣ������س������Ŀ�ʼ/����ʱ�䣬��س��ڣ�ʱ����Ƭ��������س��ڽ���ʱ�䣬
%     ������ë����ë��ƽ��ӯ������������/ë��/ë��
%     ƽ��ӯ������ƽ��������ӯ�������ܿ���ʤ�ʣ����ʣ�
%     ���ν������ӯ���ٷֱȣ����ν���������ٷֱȣ�
%     ���ӯ��ռë���ٷֱȣ�������ռë��ٷֱȣ�
%     ���������ë��������ӯ�����״����������������״���������ʽ�ռ����
%     �޳����ӯ�����׺�������ʣ��޳��������׺�������ʣ�
%     �޳�ǰN%ӯ�����׺�������ʣ��޳�ǰN%�����׺�������ʣ�
%     ��׼��������վ�ֵ
%   
% Detail: ���׵�ʱ�����м�¼��
%     ��ֵ���������׷��ã������������׷��õľ�ֵ����ֵ�����ʣ����׷���
%     ���룬���������գ����յ�״̬������4�������У�ÿ��������Ӧһ�ֲ�����״̬��
%     û�в���Ϊ0��������Ͳ��գ��в���Ϊ1���������������в���Ϊ-1.
%     ÿ�ʽ��׸���׼�����桢ÿ�ձ�׼������
%
% Trading�����׷�����
%     �ܽ��״�����ӯ�����״����������״�����
%     ӯ�����׵�ƽ��ӯ���������׵�ƽ������ӯ�����״���ռ�ܽ��״���֮��
%
% Period: ����ͳ�ƣ�
%     �ܽ�����Ƭ�����н��׵���Ƭ��������Ƶ�ʣ��н��׵���Ƭ��/�ܽ�����Ƭ������
%     ����ӯ��״̬����Ƭ�����������һ����Ƭ�������ڿ���״̬����Ƭ�����������һ����Ƭ����
%     �������ӯ����Ƭ�����������������Ƭ��
%     ƽ���������ڣ�ƽ����ʤ�������ڣ�ƽ������������
%
% StatisticalIndex�� ͳ������
%     ����ʱ���ȣ���Ȼ�죩������ʱ���ȣ������գ����ʲ���ֵ����ϵ�����ʲ���ֵ��׼��
%     ���ջر��ʣ��������ʵľ�ֵ�����ƫ�ȣ���ȡ� 
%
% RiskIndex:������
%     ���ջر��ʣ��껯�����ʣ��껯sharp���껯omegaC,�껯sortinoRatio,�껯calmarRatio,
%     �껯sterlingRatio,�껯burkeRatio
% 
% ��Example��:
% [DisplayData] = Backtest(signal, bars, configure)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ChenJie, V1.0, ��Թ�Ʊ��ϵĻز⡣
% 
% Qichao Pan, Han Wu, 2013/04/19, V2.0
% ��Ϊ����ڻ��Ļز�
% 
% Qichao Pan, 2013/04/2, V3.0
% ȫ���⣬����ṹ���Ż��㷨�����ע��
% 
% LXY, 2013/08/16 , V4.0
% ��Թ�ָ�ڻ���ÿ��ֻ����һ��
% �޸�sortino ratio��ÿ�ʽ��׵����桢ÿ�����桢���س���
% ������һ���ܸ��µ����ֵ
% ���������Ķ�������ӯ���ȵ��㷨
% ��ָ���б�׼���Ķ���Ϊ����Ե�ʱ���ֳɱ�������ȡ�

% LXY, 2013/08/21 , V4.1
% ��Թ�ָ�ڻ��������� ÿ�ο��Խ��ײ��������������������� ��ģʽ
% ��Ҫ������3�����㺯���������˰��������������źŵļ���ģʽ
% ������ ���ٿ�����������࿪����������ͱ�֤�����2���������
% Ϊ����µļ���ģʽ��ÿ�θ�����������style2���������˲����������
% �����SOA��ÿ����Ƭ��Ŀ�����BUG
% ��Ϊģʽ����������1�֣����¼��������ʲ����س������

% LXY, 2013/08/24 , V4.2
% ��������ּ���ģʽ��ÿ�θ����ܸ˱���style3��

%GX,2013/9/1,V5.1
%��ԼӲ�����������Ƚ��ȳ����ִ��ף�ÿ�ʽ��ף�ÿ�ֽ�������tradeList,tradeLists,tradeListh
%����ָ�����tradeListh���㣬ʤ�ʼ���ÿ��ʤ�ʣ�Ҳ��ÿ��ʤ��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%
Time = bars.time;
if configure.orderStyle == 2
    signal(abs(signal)<configure.min_open) =...
        sign(signal(abs(signal)<configure.min_open))*configure.min_open;   
    signal(abs(signal)>configure.max_open)=...
        sign(signal(abs(signal)>configure.max_open))*configure.max_open;   
end
%% ���ļ���
% ����ÿ��ʱ����Ƭ�µĳɽ������ɽ���ʲ���ֵ�����׷��ã����ƽ��׳ɱ����ʲ���ֵ��ͷ���ģ
[volume,account,tradingCost,accountNoCost,position,signal_adj] = calc_account_v2(bars,signal, configure);
% ����ÿ��ʱ����Ƭ�����룬���������գ����յ�״̬
[sig_buy,sig_sell, sig_sellShort, sig_buy2Cover] = calc_buysellmark(signal,configure);

% ����ÿ�ν��׵���ʼʱ�䣬�����������������
% tradeList:���ף�tradereturn,���򣬿�ʼʱ�䣬����ʱ�䣬ӯ������������������
% tradeLists:ÿ�ʽ��ף�tradereturn,���򣬿�ʼʱ�䣬����ʱ�䣬ӯ���������������һ�����ж��ƽ��ʱ�㣬��������ͬ�ı�����
% tradeListh:ÿ�ֽ��ף�tradereturn,���򣬿�ʼʱ�䣬����ʱ�䣬ӯ������������
[tradeList] = calc_tradeList_v2( signal,account,Time,bars,configure);
[tradeLists,tradeListh]=calc_tradeList_sv2(signal,account,Time,bars,configure,tradeList);

%% �����˻���ֵ�ķ���

% ��ʼ�ʲ���ֵ/�����ʲ���ֵ/�ʲ����ֵ/�ʲ���Сֵ
DisplayData.Main.initAccount = account(1,1); 
DisplayData.Main.finalAccount = account(end,1);
DisplayData.Main.maxAccount = max(account);
DisplayData.Main.minAccount = min(account);
% ���׷��ü���
DisplayData.Main.cost = sum(tradingCost); 
% �ʲ���ֵ������
DisplayData.Main.netGain = account(end)/account(1)-1; 

% ���س������س��� ���س������Լ����Ƕ�Ӧ��ʱ��
[maxDDR,MDDs,MDDe,maxDDD,m_index3] = calculateMaxDD(account, bars, configure);
DisplayData.Main.maxDDR_asset = calculateMaxDD_asset(account);%���ǳ�ʼ�ʽ�Ļس�
DisplayData.Main.maxDrawdown =maxDDR;               % ���س������棩
DisplayData.Main.maxDrawdownBegT = MDDs;  % ���س������棩�Ŀ�ʼʱ��
DisplayData.Main.maxDrawdownEndT = MDDe;  % ���س������棩�Ŀ�ʼʱ��
DisplayData.Main.longestDrawdownDuration =maxDDD;       % ���س��ڣ�bar����
DisplayData.Main.longestDdrawdownEndT =datestr(Time(m_index3),31);       % ���س��ڣ�bar��������ʱ��

% �ʲ���ֵ�� ��׼��/����ֵ-��ʼֵ��, �ʲ���ֵ�ı�׼��
[DisplayData.StatisticalIndex.CoefficientOfVariance,DisplayData.StatisticalIndex.StandardDeviation] =...
    CalcCoefficientofvariance (account); 

% ����ʽ�ռ����
DisplayData.Main.maxUsedFundRatio =...
    max(abs(position.*bars.close*configure.marginRate*configure.multiplier)./account);

% Buysellpoint �����嵥
DisplayData.oprnList.data = calc_buysellpoint(bars,account,volume,configure); % �����BuySellPoint ����

DisplayData.Detail.account = account;        % �ʲ���Ͼ�ֵ��ʱ�����У��۳����׷��ã�
DisplayData.Detail.position = position; 
DisplayData.Detail.volume = volume; 
DisplayData.Detail.accountNoCost = accountNoCost;   %�ʲ���ϵ��޽��׷Ѿ�ֵ �����轻�׷���Ϊ0�� 
DisplayData.Detail.tradingCost = tradingCost;  % �ʲ���Ͻ��׷��õ�ʱ������
DisplayData.Detail.sig_buy = sig_buy;          % ��¼ÿ�ζ�ֿ����źŵ�ʱ�����У��࿪��ʱ�����У�
DisplayData.Detail.sig_sell = sig_sell;          % ��¼ÿ�ζ��ƽ���źŵ�ʱ�����У���ƽ��ʱ�����У�
DisplayData.Detail.sig_sellShort = sig_sellShort;  % ��¼ÿ�οղֿ����źŵ�ʱ�����У��տ���ʱ�����У�
DisplayData.Detail.sig_buy2Cover = sig_buy2Cover;  % ��¼ÿ�οղ�ƽ���źŵ�ʱ�����У���ƽ��ʱ�����У�
DisplayData.Detail.tradeList = tradeList; 
DisplayData.Detail.tradeLists= tradeLists;
DisplayData.Detail.tradeListh= tradeListh;

%130816 ���룺
% ÿ�ν��ױ�׼������ gap
[nrow,~] = size(tradeList);
DisplayData.Detail.gap = zeros(nrow,1);

for i = 1:nrow
    gap_temp = account(bars.time == tradeList(i,4)) -...
        account(bars.time == tradeList(i,3));
    DisplayData.Detail.gap(i) = gap_temp / (configure.multiplier *...
        bars.open(find(bars.time == tradeList(i,3))+1) *...
        (1 + configure.cost) * configure.min_open);
end

% ÿ�ν��ױ�׼������ gap
%DisplayData.Detail.gap_perhand = DisplayData.Detail.gap./tradeList(:,7)...
   % *configure.min_open;

% ÿ�ձ�׼������ rev

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

%% ������Ƭ�����ʵķ���

returns_slice=diff(account)./account(1:end-1);   % ÿ��bar�������ʣ�ʱ������
DisplayData.Detail.returns_slice=returns_slice;        

% ����������bar�ĸ�������ø������bar�ĸ���
DisplayData.Period.win_slices = sum(returns_slice>0);   % ����������bar���������ж���ȷ��bar����
DisplayData.Period.lose_slices = sum(returns_slice<0);  % ��ø������bar���������ж������bar����

% �������ӯ��bar���Ϳ���bar��
[DisplayData.Period.maxConWinSlices,DisplayData.Period.maxConLoseSlices] = CalculatemaxConSGN(returns_slice) ; 

% ����ʱ�䳤�ȡ�bar��
DisplayData.Period.totalSlices =length(Time); 

% �н��׵�bar��
DisplayData.Period.transSlices =sum(diff(position)~=0); 

% �н��׵�bar��/������bar��
DisplayData.Period.transFrequ = DisplayData.Period.transSlices/DisplayData.Period.totalSlices; 

% ��������ϵ��
R = returns_slice;
rf = configure.riskfreebench;
timeSlice = mode(diff(Time));
slicesPerDay = 1/24*4.5/timeSlice;
Rf = rf/(250*slicesPerDay);
Rf = Rf*ones(size(R));

if configure.riskIndex ==1
%     % �����RiskIndex ��Ч�����ͷ���ָ��
%     a = configure.vara;
%     varmethod = configure.varmethod;
%     %     ����VaR Ŀǰֻ�з���Э��������෽���´���������
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
    DisplayData.RiskIndex.sharperatio = SharpeRatio( R,Rf,slicesPerDay);    % R ÿ�������ʲ���ֵ�������ʡ� Rf risk-free rate.
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


%% �����������ʵķ���

% ������������,��barΪ���㵥λ����Ϊ�������ʼ��㡣
returns_day = calc_series_returns(account,bars.time);

% ����ʱ���ȣ��գ�ͳ��
tradingdate = unique(floor(bars.time));
DisplayData.StatisticalIndex.testdayNatural = floor(tradingdate(end))-floor(tradingdate(1))+1;
DisplayData.StatisticalIndex.testdayTrading = length(tradingdate);

% ���ռ���������ʾ�ֵ�Ͳ�����
DisplayData.StatisticalIndex.returns_day_m = mean(returns_day(:,2));
DisplayData.StatisticalIndex.returns_day_s = std(returns_day(:,2));
DisplayData.StatisticalIndex.returns_day_kur = kurtosis(returns_day(:,2));  % ��� ����3����̬�ֲ�Ҫ���ͣ�С��3����̬�ֲ�Ҫƽ̹
DisplayData.StatisticalIndex.returns_day_ske = skewness(returns_day(:,2));  % ƫ�� С��0��ƫ̬������0��ƫ̬
DisplayData.StatisticalIndex.TotalReturn = account(end)/account(1)-1;


%% ���׷���������tradeList �� tradeReturn �ķ���

% ���׻ر���
 tradeReturns=tradeListh(:,6);   
 winIndex = find(tradeReturns>0);
 loseIndex = find(tradeReturns<0);

% ����ӯ����, �����Ѿ������˽��׷��á�
[DisplayData.Trading.gainNum,...
    DisplayData.Trading.lossNum,...
    DisplayData.Trading.tradeNum,...
    DisplayData.Trading.avgGain,...
    DisplayData.Trading.avgLoss,...
    DisplayData.Trading.winRatio] = calc_winloseratio(tradeListh);



% ëӯ
 DisplayData.Main.grossWin = sum(tradeReturns(tradeReturns>0)); 
 
% ë��
 DisplayData.Main.grossLose = sum(tradeReturns(tradeReturns<0)); 
 
% ������ƽ��ӯ��
 DisplayData.Main.netprofit = sum(tradeReturns); 
 DisplayData.Main.avgWinLose = mean(tradeReturns); 
 
% ƽ��ӯ������ƽ������
 DisplayData.Main.aveWinDivideAveLoss = DisplayData.Trading.avgGain/...
     DisplayData.Trading.avgLoss;
  
% ��ӯ�������ܿ���
 DisplayData.Main.groWinDivideGroLoss =DisplayData.Main.grossWin/DisplayData.Main.grossLose;

% ӯ������
 DisplayData.Main.winRate = length(winIndex)/length(tradeReturns);
 DisplayData.Main.winRates=sum(tradeLists(:,6)>0)/size(tradeLists,1);
 
% �������
 DisplayData.Main.loseRate = length(loseIndex)/length(tradeReturns);

% ƽ����������
DisplayData.Period.aveTransPeriod =mean(tradeListh(:,4)-tradeListh(:,3));

% ƽ��ӯ������
DisplayData.Period.aveWinPeriod = mean(tradeListh(winIndex,4)-tradeListh(winIndex,3));

% ƽ����������
DisplayData.Period.aveLossPeriod = mean(tradeListh(loseIndex,4)-tradeListh(loseIndex,3));
 
% ���ӯ����%)
DisplayData.Main.maxWinRet = max(tradeReturns);
 
% ������ ��%��
DisplayData.Main.maxLoseRet = min(tradeReturns);
 
% ���ӯ��������ӯ��
DisplayData.Main.maxWinDivideGrossWin=DisplayData.Main.maxWinRet/DisplayData.Main.grossWin;

% ����������ܿ���
DisplayData.Main.maxLoseDivideGrossLose=DisplayData.Main.maxLoseRet/DisplayData.Main.grossLose;

% ���������ë��
DisplayData.Main.netGainDivideMaxLose=DisplayData.Main.netGain/DisplayData.Main.grossLose;

% ������ӯ������
DisplayData.Main.maxConWinTime = maxConGainTime(tradeReturns);
 
% �������������
DisplayData.Main.maxConLoseTime = maxConLossTime(tradeReturns);

% �۳����ӯ����������,�������account�����ʲ��䶯���
 DisplayData.Main.winRateExcMaxRet = gainRateExcMax(tradeListh(:,1));

% �۳��������������,�������account�����ʲ��䶯���
 DisplayData.Main.loseRateExcMaxRet = lossRateExcMax(tradeListh(:,1));
 
% �۳�ǰN%���ӯ����������ʣ����ȱʡ��Ϊ5%��
 DisplayData.Main.gainRateExcMaxNpercentRet =gainRateExcMaxNpercentRet(tradeListh(:,1));

% �۳�ǰN%�������������� �����ȱʡ��Ϊ5%��
 DisplayData.Main.loseRateExcMaxNpercentRet =loseRateExcMaxNpercentRet(tradeListh(:,1));
  
% ������ë����
% ӯ������������ȥ��ƽ�������ڳ��Բ���ӯ�����׵�ƽ��ӯ�������ڽ���ԭ�����������������ֵ���ܹ����׸ò��ԣ�����Ը���.�μ�MC�Ĳ��Ա���
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