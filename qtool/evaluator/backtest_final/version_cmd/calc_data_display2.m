function  Displaydata = calc_data_display2(input1,input2,input3,~,Configure)

startdate = datestr(input2(1,1),29); % ����������Input�����ղ�ͬ������������ģ�ʹ���������
enddate = datestr(input2(end,1),29); % �����ֹ����Input�н�ֹ�ղ�ͬ������������ģ�ʹ����Ľ�ֹ��
% ֤ȯ����
secucode = input1(1,2:end);

% ��ʼ�յ���ֹ��֮���������Ȼ��
Date = (input2(1,1):input2(end,1))';
Day = datestr(Date,29);
global Gildata;

% ������������������
marketdata = cell(size(secucode,2),1);
type = getSecuritytype(secucode);
if Configure.downloadmark ==1 && all(type~=1&type~=9)
    % ������д��Cache
    writeintocache_backtest(secucode,datestr(input2(1,1)-1,29),enddate,Configure.Path_Backtest_Cache);
    % ��Cache�ж�ȡ��������
    for Index = 1:size(secucode,2)
        SecuCode = secucode{Index};
        marketdata{Index} = readfromcache_backtest(SecuCode,datestr(input2(1,1)-1,29),enddate,Configure.Path_Backtest_Cache);
        marketdata{Index} = marketdata{Index}(:,[1,5]);
    end
else
    for Index = 1:size(secucode,2)
        SecuCode = secucode{1,Index};
        type = getSecuritytype(SecuCode);
        if type ==1
            ratio = fetch(Gildata,'FS_FF_INFO_MARGIN','ContractCode',innercode(SecuCode));
            unit = 300*ratio{1,1}{1,1};
            close_3 = DQ_QueryDailyData_V(SecuCode,Day,'Settle')*unit;
        elseif type ==9
            ratio = fetch(Gildata,'FS_CF_INFO_MARGIN','ContractCode',innercode(SecuCode));
            unit =1* ratio{1,1}{1,1};
            close_3 = DQ_QueryDailyData_V(SecuCode,Day,'Settle')*unit;
        else
            close_3 = DQ_QueryDailyData_V(SecuCode,Day,'Close',3);
        end
        Temp_Data = [Date,close_3'];
        marketdata{Index} = Temp_Data;
    end
end

% �������֤ȯÿ�ճɽ�������������ÿ�����ʲ���ֵ
[~,Account] = calc_account2(marketdata,input1,input2);

% �������֤ȯ��������������������
% [close_buy,close_sell] = calc_buysellmark(Volume);
%
% Displaydata.marketdata = marketdata;  % ����֤ȯ���̼�����
% Displaydata.close_buy = close_buy;    % ����֤ȯ���������̼�����
% Displaydata.close_sell = close_sell; % ����֤ȯ���������̼�����
returns=diff(Account)./Account(1:end-1);  %ÿ���������

accum_returns=cumprod(returns+1); % �ۼ�������
Asset_v = cell2mat(input1(2,:));
Asset_v = cumsum([Asset_v;input2(:,2:end)]);
Asset_v = Asset_v(2:end,:);

price = input3;
type = getSecuritytype(secucode);
for  Index = 1:length(type)
    if type(Index)==1
        ratio = fetch(Gildata,'FS_FF_INFO_MARGIN','ContractCode',innercode(SecuCode));
        unit = 300*ratio{1,1}{1,1};
        price(:,Index)=price(:,Index)*unit;
    elseif type(Index)==9
        ratio = fetch(Gildata,'FS_CF_INFO_MARGIN','ContractCode',innercode(SecuCode));
        unit =1* ratio{1,1}{1,1};
        price(:,Index)=price(:,Index)*unit;
    end
end

[Displaydata.wintradetime,Displaydata.losetradetime,Displaydata.totaltradetime,...
    Displaydata.win_averet,Displaydata.lose_averet,Displaydata.winratio1,Displaydata.winratio2]...
    = calc_winloseratio(input2,Asset_v,price,Configure.benchmark,Configure.downloadmark);

% ����������������ͬ��ҵ����׼������
Displaydata.accumreturn = accum_returns(end)-1;




% �����ۼ����������к���������������
% if  isfield(Configure,'benchmark')
%     [IndexCode,weight] = readindexcode(Configure.benchmark);
%     Temp = F_SERIES_INDEXRETURN(IndexCode{1},startdate,enddate,1,1,1);
%     Indexreturn2 = ones(size(Temp,1),size(IndexCode,1));
%     for Index =1:size(IndexCode,1)
%         Temp = F_SERIES_INDEXRETURN(IndexCode{Index},startdate,enddate,1,1,1);
%         Loc =cellfun(@isempty,Temp(:,2));
%         Temp(Loc,2) = {0};
%         Temp = cell2mat(Temp(:,2));
%         Indexreturn2(:,Index) = Temp;
%     end
%     IR = Indexreturn2* weight;
%     Displaydat.aIR_acc = [Date,cumprod(IR+1)];
% end

% ��ӯ���������ܿ�������
% Displaydata.win_day = size(returns(returns>0),1);
% Displaydata.lose_day = size(returns(returns<0),1);
% �������ӯ�����������������������
% Displaydata.maxConwl = CalculatemaxConSGN(returns) ;

% ���س������س��� ���س������Լ����Ƕ�Ӧ��ʱ��
[Displaydata.drawdownratio,ddr_index,Displaydata.drawdown,dd_index,Displaydata.drawdownduration,...
    ddd_index]=calculateMaxDD(returns);
Displaydata.drawdown = Displaydata.drawdown;
Displaydata.drawdown_time = datestr(Date(dd_index),29);
Displaydata.drawdownratio_time = datestr(Date(ddr_index),29);
Displaydata.drawdownduration_time = datestr(Date(ddd_index),29);


Displaydata.interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark,2,2);
% ������ʼ�պͽ�ֹ��֮�����Ȼ�պͽ�����
% tradingdate = DQ_GetDate_V('000001.SHI',startdate,enddate,0,Configure.downloadmark);
% Displaydata.testday(1) = datenum(enddate) - datenum(startdate) + 1;
% Displaydata.testday(2) = size(tradingdate,1);
% ��ʼ�ʲ���ֵ�������ʲ���ֵ
% Displaydata.initAsset = Account(1,1);
% Displaydata.enddateAsset = Account(end,1);
% [Displaydata.Coefficientofvariance,Displaydata.Standarddeviation] = CalcCoefficientofvariance (Account);
% �������������У�ǰ������δ�޳����������ڣ������޳���
% interval_returns_d = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
% interval_returns_w = calc_series_returns(Account,startdate,enddate,2,Configure.downloadmark,2,2);
% interval_returns_m = calc_series_returns(Account,startdate,enddate,3,Configure.downloadmark,2,2);
% interval_returns_q = calc_series_returns(Account,startdate,enddate,4,Configure.downloadmark,2,2);
% interval_returns_h = calc_series_returns(Account,startdate,enddate,5,Configure.downloadmark,2,2);
% interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark,2,2);
% ���������ʾ�ֵ�Ͳ�����
% Displaydata.interval_returns_d_m = mean(interval_returns_d(:,2));
% Displaydata.interval_returns_d_s = std(interval_returns_d(:,2));
% Displaydata.interval_returns_d_kur = kurtosis(interval_returns_d(:,2));  % ��� ����3����̬�ֲ�Ҫ���ͣ�С��3����̬�ֲ�Ҫƽ̹
% Displaydata.interval_returns_d_ske = skewness(interval_returns_d(:,2));  % ƫ�� С��0��ƫ̬������0��ƫ̬

% R = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
% R = R(:,2);
% Displaydatastd = std(R);

% if r13 ==1
% �����RiskIndex ��Ч�����ͷ���ָ��
%     a = str2double(Configure.vara);
%     varmethod = str2double(Configure.varmethod);
%     rf = str2double(Configure.riskfreebench);
%
%     %     ����VaR Ŀǰֻ�з���Э��������෽���´���������
%     switch varmethod
%         case 1
%             Displaydata.VaR = portvrisk(mean(R),std(R),a);
%         case 2
%         case 3
%         case 4
%         otherwise
%     end
%
%     if rf == -1
%         Rf = F_SERIES_RISKFREERETURN(startdate,enddate,1,2,1);
%         Rf = cell2mat(Rf(:,2));
%         Rf = Rf(2:end);
%     else
%         Rf = rf/365;
%         Rf = Rf*ones(size(R,1),1);
%     end
%     Rm = F_SERIES_INDEXRETURN(Configure.marketbench,startdate,enddate,1,2,1);
%     Rm = cell2mat(Rm(:,2));
%     Rm = Rm(2:end);
%     if  isfield(Configure,'benchmark')
%         [IndexCode,weight] = readindexcode(Configure.benchmark);
%         Temp = F_SERIES_INDEXRETURN(IndexCode{1},startdate,enddate,1,2,1);
%         Indexreturn2 = nan(size(Temp,1),size(IndexCode,1));
%         for Index =1:size(IndexCode,1)
%             Temp = F_SERIES_INDEXRETURN(IndexCode{Index},startdate,enddate,1,2,1);
%             Temp = cell2mat(Temp(:,2));
%             Indexreturn2(:,Index) = Temp;
%         end
%         IR = Indexreturn2* weight;
%         IR = IR(2:end);
%
%         Displaydata.trackingerror = annualizetrackingerror(R,IR,1);
%         Displaydata.InformationRatio= mean(R-IR)/std(R-IR);
%     else
%         Displaydata.trackingerror = nan;
%         Displaydata.InformationRatio = nan;
%     end
%
%     Displaydata.annstd =annualizestdev(R,1);
%     Displaydata.sharperatio = SharpeRatio( R,Rf);
%     Displaydata.Beta =betaCoefficient( R,Rm);
%     Displaydata.Alpha =alphaCoefficient( R,Rm,Rf,Displaydata.Beta);
%     Displaydata.Treynor = treynorCoefficient( R,Rf,Displaydata.Beta);
%
% end


end
