%��Ҫ�޸ĵĺ�Լ����
contractCode = 'IF1410.CFE';
% �껯�޷���������
nonRiskRate = 0.05;
% �꽻������
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
% % д����Ӧ�Ľ���ʱ�䣬ת��Ϊ�룬��Ϊ��ͼ��Ҫ�ĺ�����
% tradingTime = [9*3600:11*3600+30*60,13*3600:15*3600];
% tradingTime = tradingTime'/(24*3600);
% nTime       = length(tradingTime);
% % д�����ж�Ӧ�Ľ�����
% tradingDayNum = datenum(tradingDay);
% tradingTime = repmat(tradingTime,length(tradingDayNum),1);
% tradingDayNum = repmat(tradingDayNum,1,nTime);
% tradingTime = tradingTime + reshape(tradingDayNum',[],1);


% ��ȡ��ָ�ڻ���Ӧ�����ڵ����м۸�
priceFut = DH_Q_HFP_Future(contractCode,tradingDay(1,:),tradingDay(end,:),'ClosePrice');
% ��ȡָ����Ӧ�����ڵ����м۸�
priceInd = DH_Q_HFP_Stock('000300.SH',tradingDay(1,:),tradingDay(end,:),'ClosePrice');

% ɾ��ָ����9:30�Լ�15:00֮�������
HM = str2num(datestr(priceInd(:,1),'HHMM'));
beforeTrade = find(HM<930);
afterTrade = find(HM>1500);
priceInd([beforeTrade;afterTrade],:) = [];

% ɾ����ָ�ڻ��ظ�ʱ������
repeatIndex = find(priceFut(2:end,1)-priceFut(1:end-1,1) == 0);
priceFut(repeatIndex,:) = [];
% �Թ�ָ�ڻ�����ֵ
priceFutRevise = interp1(priceFut(:,1),priceFut(:,2),priceInd(:,1));

figure(160)
plot(priceFutRevise);
hold on 
plot(priceInd(:,2),'r');
hold off
legend([contractCode(1:6),'�۸�'],'ָ���۸�');
title([contractCode(1:6),'��ָ���۸�����'])


figure(161)
% �ҳ�����ʱ�������
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
legend([contractCode(1:6),'���ֲ�'],'ʱ���ֵ����');
grid on
title([contractCode(1:6),'���ֲ�'])