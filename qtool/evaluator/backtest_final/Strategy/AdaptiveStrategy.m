% ����Ӧ���ߵ���ʱ����
% �ο��飺 "Smarter Trading: Improving Performance in Changing Markets"
% Perry J. Kaufman
% McGraw-Hill,Inc.

% The Adaptive Moving Average:
% AMA(t) = SmoothingConstant(t) * Price(t) + ( 1 - SmoothingConstant(t) ) * AMA(t-1)
% SmoothingConstant(t) = ( EfficiencyRatio(t) * FastConstant + ( 1 - EfficiencyRatio(t) ) * SlowConstant)^2
% EfficiencyRatio(t) = n���ڼ۸�䶯��λ�� / n���ڼ۸�䶯��·��
% FastConstant = 2 / ( FastPeriod + 1 )
% SlowConstant = 2 / ( SlowPeriod + 1 )

% ����Perry J. Kaufman "Smarter Trading: Improving Performance in Changing Markets"
% һ���е�136ҳ��������FastPeriodȡ2
% ����ʵ֤����������Ϊ����300ʱ��nȡ20��SlowPeriod��ȡ10��15��20��25��30�ȣ���𲻴�

% Ϊ�˱���۸�����ƶ�ʱ�����źŹ���Ƶ����������һ����С���ٽ�ֵ������Ӧ�������Ϲ�ͷ���Һ͹յ�Ĳ�𳬹��ٽ�ֵʱ�����������źţ�
% ����Ӧ�������¹�ͷ���Һ͹յ�Ĳ�𳬹��ٽ�ֵʱ�����������ź�
% �ٽ�ֵӦ�ӱ�Ĺ�Ʊ�ľ������ѡȡ���绦��300���䱨�ۻ����ϴ��ٽ�ֵ��ȡ0.5


%[output1,output2,output3]=AdaptiveStrategy('2010-01-01','2010-04-01','000300.SHI',2,30,20,100000,0.5)
function [output1,output2,output3]=AdaptiveStrategy2(StartDate,EndDate,Security,FastPeriod,SlowPeriod,n,initAsset,Threshold)
 if nargin<8
     Threshold=0; %Ĭ������£��ٽ�ֵ��Ϊ0
 end
 downloadmark=0;
 initStocks=0;
 %ȡ������
 tradingDate = DH_D_TR_MarketTradingday(1,StartDate,EndDate);
 tradingdate_num = datenum(tradingDate);
if downloadmark == 1
    Data1 = readfromcache_backtest(Security,StartDate,EndDate);
    Loc = bsxfun(@eq,Data1(:,1),tradingdate_num');
    Data = Data1(logical(sum(Loc,2)),[1,5]);
else
    Data1 = DH_Q_DQ_Stock(Security,cellstr(tradingDate),'Close',3);
    Data = [tradingdate_num,Data1];
end
%Data(isnan(Data(:,2)),:)=[];

AMA=CalculateAMA(Data(:,2),FastPeriod,SlowPeriod,n);
N=length(AMA)-1;
Volume=zeros(N,1);%��Ʊ������
Cash=zeros(N,1);%�ֽ�����
Asset=zeros(N,1);%�����ֽ�
Amount=zeros(N,1);%���ֹ�Ʊ��
Trade=zeros(N,1);%����Ƿ���
Asset(1)=initAsset;
Trade(1)=1;
Data=Data((end-N+1):end,:);
%���ײ���
for ii=2:N
    if AMA(ii)<AMA(ii-1) && AMA(ii)-AMA(ii+1)<-Threshold && Amount(ii-1)<1e-15
        Cash(ii)=-Asset(ii-1);
        Volume(ii)=Asset(ii-1)/Data(ii,2);
        Amount(ii)=Volume(ii);
        Trade(ii)=1;
    elseif AMA(ii)>AMA(ii-1) && AMA(ii)-AMA(ii+1)>Threshold && Asset(ii-1)<1e-15
        Volume(ii)=-Amount(ii-1);
        Cash(ii)=Amount(ii-1)*Data(ii,2);
        Asset(ii)=Cash(ii);
        Trade(ii)=1;
    else
        Amount(ii)=Amount(ii-1);
        Asset(ii)=Asset(ii-1);
    end
end

Trade(end) =1;
%����ӿ�    
%�۸�����ʱ�㣬����������λ���ʲ�ֵ����
Data=[Data,Cash,Volume];
Data=Data(Trade==1,:);
init1 = cellstr('cash');
init2 = cellstr(Security);
init1 = [init1;initAsset];
init2 = [init2;initStocks];
output1 = [init1,init2];
output2 = [Data(:,1),Data(:,3),Data(:,4)];
output3 = Data(:,2); 
        
%%����Ӧ���ߵļ���

function AMA=CalculateAMA(Price,FastPeriod,SlowPeriod,n)

T=length(Price)-n;
AMA=zeros(T+1,1);  % ����Ӧ��������
ER=zeros(T,1);  % Efficiency Ratio 
SumAbs=zeros(T,1);  % ER�ķ�ĸ
c=zeros(T,1);  % Smoothing constant

for i1=1:n
    SumAbs(1)=SumAbs(1)+abs(Price(i1+1)-Price(i1));
end

for i2=2:T
    SumAbs(i2)=SumAbs(i2-1)+abs(Price(i2+n)-Price(i2+n-1))...
                                     -abs(Price(i2)-Price(i2-1));
end

FastConstant=2/(FastPeriod+1);
SlowConstant=2/(SlowPeriod+1);
AMA(1)=Price(n);

for i3=1:T
ER(i3)=abs(Price(i3+n)-Price(i3))/SumAbs(i3);
c(i3)=(ER(i3)*(FastConstant-SlowConstant)+SlowConstant)^2;
AMA(i3+1)=c(i3)*Price(i3+n)+(1-c(i3))*AMA(i3);
end

end
end