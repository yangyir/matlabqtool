% 自适应均线的择时策略
% 参考书： "Smarter Trading: Improving Performance in Changing Markets"
% Perry J. Kaufman
% McGraw-Hill,Inc.

% The Adaptive Moving Average:
% AMA(t) = SmoothingConstant(t) * Price(t) + ( 1 - SmoothingConstant(t) ) * AMA(t-1)
% SmoothingConstant(t) = ( EfficiencyRatio(t) * FastConstant + ( 1 - EfficiencyRatio(t) ) * SlowConstant)^2
% EfficiencyRatio(t) = n天内价格变动的位移 / n天内价格变动的路程
% FastConstant = 2 / ( FastPeriod + 1 )
% SlowConstant = 2 / ( SlowPeriod + 1 )

% 参照Perry J. Kaufman "Smarter Trading: Improving Performance in Changing Markets"
% 一书中第136页的做法，FastPeriod取2
% 根据实证结果，当标的为沪深300时，n取20；SlowPeriod可取10、15、20、25、30等，差别不大

% 为了避免价格横向移动时交易信号过于频繁，可设置一个很小的临界值。自适应均线向上拐头，且和拐点的差别超过临界值时，发出买入信号；
% 自适应均线向下拐头，且和拐点的差别超过临界值时，发出卖出信号
% 临界值应视标的股票的具体情况选取。如沪深300，其报价基数较大，临界值可取0.5


%[output1,output2,output3]=AdaptiveStrategy('2010-01-01','2010-04-01','000300.SHI',2,30,20,100000,0.5)
function [output1,output2,output3]=AdaptiveStrategy2(StartDate,EndDate,Security,FastPeriod,SlowPeriod,n,initAsset,Threshold)
 if nargin<8
     Threshold=0; %默认情况下，临界值设为0
 end
 downloadmark=0;
 initStocks=0;
 %取出数据
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
Volume=zeros(N,1);%股票交易量
Cash=zeros(N,1);%现金交易量
Asset=zeros(N,1);%所持现金
Amount=zeros(N,1);%所持股票量
Trade=zeros(N,1);%标记是否交易
Asset(1)=initAsset;
Trade(1)=1;
Data=Data((end-N+1):end,:);
%交易策略
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
%输出接口    
%价格，买卖时点，交易量，仓位，资产值序列
Data=[Data,Cash,Volume];
Data=Data(Trade==1,:);
init1 = cellstr('cash');
init2 = cellstr(Security);
init1 = [init1;initAsset];
init2 = [init2;initStocks];
output1 = [init1,init2];
output2 = [Data(:,1),Data(:,3),Data(:,4)];
output3 = Data(:,2); 
        
%%自适应均线的计算

function AMA=CalculateAMA(Price,FastPeriod,SlowPeriod,n)

T=length(Price)-n;
AMA=zeros(T+1,1);  % 自适应均线序列
ER=zeros(T,1);  % Efficiency Ratio 
SumAbs=zeros(T,1);  % ER的分母
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