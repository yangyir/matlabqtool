%[output1,output2,output3] = MACDStrategy2('2009-06-01','2012-06-01','000001.SZ',12,26,9,100000)
function [output1,output2,output3] =MACDStrategy(StartDate,EndDate,Security,short,long,mlen,initAsset)

%  设置默认参数
if nargin<7
    initAsset=0;
end
if  nargin<6
    mlen=9;
end
if nargin<5
    long=26;
end
if nargin<4
    short=12;
end

% 设置是否从Cache中读取数据，1为从Cache中读取数据；0为联网下载数据。
downloadmark=0;
initStocks=0;
% 提取交易日
tradingdate = DH_D_TR_MarketTradingday(1,StartDate,EndDate);
tradingdate_num = datenum(tradingdate);
% 下载相应交易日内向前复权日收盘价
if downloadmark == 1
    Data1 = readfromcache_backtest(Security,StartDate,EndDate);
    Loc = bsxfun(@eq,Data1(:,1),tradingdate_num');
    Data = Data1(logical(sum(Loc,2)),[1,5]);
else
    Data1 = DH_Q_DQ_Stock(Security,cellstr(tradingdate),'Close',3);
    Data = [tradingdate_num,Data1];
end
Data(isnan(Data(:,2)),:)=[];

% 计算起始日和截止日间MACD相关指标DIFF DEA已经MACD柱序列
[diff,dea,macdval]=M_MACD(Data(:,2),short,long,mlen);
%Locate=zeros(length(macdval),1);
Data=Data(end-length(diff)+1:end,:);
Volume=zeros(length(macdval),1);%交易时间以及交易量
Asset=zeros(length(macdval),1);%持有股票数量
Amount=zeros(length(macdval),1);%总资产值
Asset1=zeros(length(macdval),1);%持有现金量

Amount(1)=initAsset;
Asset1(1)=initAsset;
%  策略执行时，证券和现金交易量、持有量以及资产总值变量情况。
for index=2:length(macdval)
% 　 买入点（DIFF向上突破DEA，DIFF和DEA均为正,持有资金量为正）
    if diff(index)>diff(index-1) && diff(index)>dea(index) && diff(index-1)<dea(index-1) && diff(index)>0 && dea(index)>0 && Asset1(index-1)>0
        Volume(index)=Asset1(index-1)/Data(index,2);
        Asset1(index)=0;
        Amount(index)=Amount(index-1);
        Asset(index)=Volume(index);
%　  卖出点 （DIFF向下跌破DEA，DIFF和DEA均为负，持有证券量为正）
    elseif diff(index)<diff(index-1) && diff(index)<dea(index) && diff(index-1)>dea(index-1) && diff(index)<0 &&dea(index)<0  && Asset(index-1)>0
         Volume(index)=-Asset(index-1);
         Asset1(index)=Asset(index-1)*Data(index,2);
         Amount(index)=Asset(index-1)*Data(index,2);
    else
%   持有点
        if  Asset(index-1)>0
            Asset(index)=Asset(index-1);
            Asset1(index)=Asset1(index-1);
            Amount(index)=Asset(index-1)*Data(index,2);
        else
%    空仓点
            Asset1(index)=Asset1(index-1);
            
            Amount(index)=Amount(index-1);
        end
       
    end
end
Data=[Data,Volume,Asset,Amount];

% 若该策略无交易则输出output1，output2和output3均为空
Data1=Data(Volume~=0,:);
if(isempty(Data1))
    output1 = [];
    output2 = [];
    output3= [];
    return;
end

% 输出时应有首日和截止日
if  Data1(1,1) ~= Data(1,1)
    Data1 = [Data(1,:);Data1];
end
if Data1(end,1) ~= Data(end,1)
    Data1 = [Data1;Data(end,:)];
end
Data = Data1;

origin(1,1) = 0;
new(1,1) = origin(1,1) + Volume(1,1);
for index3 = 2:size(Data,1)
    origin(index3,1) = new (index3-1,1);
    new(index3,1) = origin(index3,1) + Data(index3,end-2);
end
cash = -Data(:,2).*Data(:,end-2);
output2 = [Data(:,1),cash,Data(:,end-2)];
init1 = cellstr('cash');
init2 = cellstr(Security);
init1 = [init1;initAsset];
init2 = [init2;initStocks];
output1 = [init1,init2];
output3 = Data(:,2);

% MACD中各指标DIFF，DEA以及MACD柱的计算
function [DIFF,DEA,MACDval]=M_MACD(Price,short,long,mlen)
   if nargin<4
       mlen=9;
   end
   if nargin<3
      long=26;
   end
   if nargin<2
       short=12;
   end
   % output=zeros(size(Price,1),1);
   ema1=EMA(Price,short);
   ema2=EMA(Price,long);
   dic=min(length(ema1),length(ema2));
   DIFF=ema1(end-dic+1:end)-ema2;
   DEA=EMA(DIFF,mlen); 
   DIFF=DIFF(mlen:end);
   MACDval=2*(DIFF-DEA);
  function  output1= EMA(Price,len)
   output1=zeros(size(Price,1),1);
   output1(1)=Price(1);
    for i=len:length(Price)
      output1(i)=2/(len+1)*output1(i-1)+(len-1)/(len+1)*Price(i);
    end
    output1=output1(len:end);
  end
 end 

end

