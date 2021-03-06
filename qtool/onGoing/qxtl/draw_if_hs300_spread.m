%需要修改的合约名称
contractCode = 'IF1410.CFE';
% 年化无风险收益率
nonRiskRate = 0.05;
% 年交易天数
allTradingDayCount = 245;
firstDay = DH_D_F_FListedDay(contractCode);
lastDay = DH_D_F_FLastDay(contractCode);
alltradingDay = DH_D_TR_MarketTradingday(3,firstDay,lastDay);
daoqiri = size(alltradingDay,1):-1:1;
if datenum(lastDay)>today
    lastDay = today;
end
tradingDay = DH_D_TR_MarketTradingday(3,firstDay,lastDay);

daoqiri = daoqiri(1:size(tradingDay,1));
timeValue = daoqiri/allTradingDayCount*nonRiskRate;
% % 写出对应的交易时间，转化为秒，即为画图需要的横坐标
% tradingTime = [9*3600:11*3600+30*60,13*3600:15*3600];
% tradingTime = tradingTime'/(24*3600);
% nTime       = length(tradingTime);
% % 写出所有对应的交易日
% tradingDayNum = datenum(tradingDay);
% tradingTime = repmat(tradingTime,length(tradingDayNum),1);
% tradingDayNum = repmat(tradingDayNum,1,nTime);
% tradingTime = tradingTime + reshape(tradingDayNum',[],1);


% 获取股指期货对应日期内的所有价格
priceFut = DH_Q_HFP_Future(contractCode,tradingDay(1,:),tradingDay(end,:),'ClosePrice');
% 获取指数对应日期内的所有价格
priceInd = DH_Q_HFP_Stock('000300.SH',tradingDay(1,:),tradingDay(end,:),'ClosePrice');

% 删除指数在9:30以及15:00之后的数据
HM = str2num(datestr(priceInd(:,1),'HHMM'));
beforeTrade = find(HM<930);
afterTrade = find(HM>1500);
priceInd([beforeTrade;afterTrade],:) = [];

% 删除股指期货重复时间数据
repeatIndex = find(priceFut(2:end,1)-priceFut(1:end-1,1) == 0);
priceFut(repeatIndex,:) = [];
% 对股指期货做插值
priceFutRevise = interp1(priceFut(:,1),priceFut(:,2),priceInd(:,1));

figure(160)
plot(priceFutRevise);
hold on 
plot(priceInd(:,2),'r');
hold off
legend([contractCode(1:6),'价格'],'指数价格');
title([contractCode(1:6),'与指数价格走势'])


figure(161)
% 找出所有时间的日期
tradingDayNum = datenum(tradingDay);
tradeDayNo  = floor(priceInd(:,1));
nonRishValue    = zeros(size(priceFutRevise));

for k = 1:length(tradingDayNum)
    nonRishValue(tradeDayNo == tradingDayNum(k)) = timeValue(k)*priceFutRevise(tradeDayNo == tradingDayNum(k));
end
plot(priceFutRevise-priceInd(:,2));
hold on 
    plot(nonRishValue,'r');
hold off
legend([contractCode(1:6),'期现差'],'时间价值曲线');
grid on
title([contractCode(1:6),'期现差'])
