function  Displaydata = calc_data_display2(input1,input2,input3,~,Configure)

startdate = datestr(input2(1,1),29); % 这里首日与Input中首日不同，这里首日是模型处理后的首日
enddate = datestr(input2(end,1),29); % 这里截止日与Input中截止日不同，这里首日是模型处理后的截止日
% 证券代码
secucode = input1(1,2:end);

% 起始日到截止日之间的所有自然日
Date = (input2(1,1):input2(end,1))';
Day = datestr(Date,29);
global Gildata;

% 下载所需日行情数据
marketdata = cell(size(secucode,2),1);
type = getSecuritytype(secucode);
if Configure.downloadmark ==1 && all(type~=1&type~=9)
    % 将数据写入Cache
    writeintocache_backtest(secucode,datestr(input2(1,1)-1,29),enddate,Configure.Path_Backtest_Cache);
    % 从Cache中读取所需数据
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

% 计算各种证券每日成交量，持有量和每日总资产价值
[~,Account] = calc_account2(marketdata,input1,input2);

% 计算各种证券买入或者卖出天数的序号
% [close_buy,close_sell] = calc_buysellmark(Volume);
%
% Displaydata.marketdata = marketdata;  % 各个证券收盘价序列
% Displaydata.close_buy = close_buy;    % 各个证券购买日收盘价序列
% Displaydata.close_sell = close_sell; % 各个证券出售日收盘价序列
returns=diff(Account)./Account(1:end-1);  %每天的收益率

accum_returns=cumprod(returns+1); % 累计收益率
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

% 计算最终收益率与同期业绩基准收益率
Displaydata.accumreturn = accum_returns(end)-1;




% 计算累计收益率序列和区间收益率序列
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

% 总盈利天数与总亏损天数
% Displaydata.win_day = size(returns(returns>0),1);
% Displaydata.lose_day = size(returns(returns<0),1);
% 最大连续盈利天数与最大连续亏损天数
% Displaydata.maxConwl = CalculatemaxConSGN(returns) ;

% 最大回撤、最大回撤比 最大回撤周期以及它们对应的时间
[Displaydata.drawdownratio,ddr_index,Displaydata.drawdown,dd_index,Displaydata.drawdownduration,...
    ddd_index]=calculateMaxDD(returns);
Displaydata.drawdown = Displaydata.drawdown;
Displaydata.drawdown_time = datestr(Date(dd_index),29);
Displaydata.drawdownratio_time = datestr(Date(ddr_index),29);
Displaydata.drawdownduration_time = datestr(Date(ddd_index),29);


Displaydata.interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark,2,2);
% 计算起始日和截止日之间的自然日和交易日
% tradingdate = DQ_GetDate_V('000001.SHI',startdate,enddate,0,Configure.downloadmark);
% Displaydata.testday(1) = datenum(enddate) - datenum(startdate) + 1;
% Displaydata.testday(2) = size(tradingdate,1);
% 初始资产总值和最终资产总值
% Displaydata.initAsset = Account(1,1);
% Displaydata.enddateAsset = Account(end,1);
% [Displaydata.Coefficientofvariance,Displaydata.Standarddeviation] = CalcCoefficientofvariance (Account);
% 区间收益率序列（前面收益未剔除不完整周期，这里剔除）
% interval_returns_d = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
% interval_returns_w = calc_series_returns(Account,startdate,enddate,2,Configure.downloadmark,2,2);
% interval_returns_m = calc_series_returns(Account,startdate,enddate,3,Configure.downloadmark,2,2);
% interval_returns_q = calc_series_returns(Account,startdate,enddate,4,Configure.downloadmark,2,2);
% interval_returns_h = calc_series_returns(Account,startdate,enddate,5,Configure.downloadmark,2,2);
% interval_returns_y = calc_series_returns(Account,startdate,enddate,6,Configure.downloadmark,2,2);
% 区间收益率均值和波动率
% Displaydata.interval_returns_d_m = mean(interval_returns_d(:,2));
% Displaydata.interval_returns_d_s = std(interval_returns_d(:,2));
% Displaydata.interval_returns_d_kur = kurtosis(interval_returns_d(:,2));  % 峰度 大于3比正态分布要陡峭，小于3比正态分布要平坦
% Displaydata.interval_returns_d_ske = skewness(interval_returns_d(:,2));  % 偏度 小于0左偏态，大于0右偏态

% R = calc_series_returns(Account,startdate,enddate,1,Configure.downloadmark,2,2);
% R = R(:,2);
% Displaydatastd = std(R);

% if r13 ==1
% 输出到RiskIndex 绩效评估和风险指标
%     a = str2double(Configure.vara);
%     varmethod = str2double(Configure.varmethod);
%     rf = str2double(Configure.riskfreebench);
%
%     %     计算VaR 目前只有方差协方差法，其余方法下次升级加入
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
