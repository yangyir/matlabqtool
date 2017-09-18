% [output1,output2,output3] = MA('2010-01-01','2013-01-17','000002.SZ',5,10,100000)

 function [output1,output2,output3]=MA(StartDate,EndDate,Security,MALength1,MALength2,initAsset)

% 这里的Security只股票、债券或者交易所交易的基金。不过因为不同证券展现形式不同，我们这里
% 只考虑单独一种ETF基金。不进行卖空操作。

load('MAdata');
if nargin<5
    initAsset = 0;
end
%  downloadmark 为0，采用实时下载方式下载数据；downloadmark为1时，采用读Cache方式，脱机展现模式。
downloadmark = 0;
initStocks = 0;

% 这一步，我们将所有需要数据取出


tradingdate = DH_D_TR_MarketTradingday(1,StartDate,EndDate);%这里使用的交易日是上海证券交易所开放日期，如果有加入期货后面需要进行一些调整
tradingdate_num = datenum(tradingdate);

if downloadmark == 1 
    Data1 = readfromcache_backtest(Security,StartDate,EndDate);
    Loc = bsxfun(@eq,Data1(:,1),tradingdate_num');
    Data = Data1(logical(sum(Loc,2)),[1,5]);
else
    Data1 = DH_Q_DQ_Stock(Security,cellstr(tradingdate),'Close',3);
    Data = [tradingdate_num,Data1];
end

Data(isnan(Data(:,2)),:)=[];    % 这句话没有意义

if MALength1==MALength2              % 只求一个均价
    
    Data_ma=ma(Data(:,2),MALength1);     % 均线数据
    Locate=zeros(length(Data_ma),1);     %
    Volume=zeros(length(Data_ma),1);%交易时间以及交易量
    Asset=zeros(length(Data_ma),1);%持有股票数量
    Amount=zeros(length(Data_ma),1);%资产值
    
    Locate((Data_ma>Data(MALength1:end,2)))=1;
    Locate((Data_ma<Data(MALength1:end,2)))=-1;
    Amount(1)=initAsset;
    
    for Index2=2:length(Data_ma)
        if Locate(Index2-1)~=1&&Locate(Index2)==1   % 昨天看空，今天看多
            Volume(Index2)=Amount(Index2-1)/Data(MALength1+Index2-1,2);     %购入股票，全仓进出
            Amount(Index2)=Amount(Index2-1);                                %今天的资产价值 = 昨天的资产
            Asset(Index2)=Volume(Index2);                                       
            
        elseif Locate(Index2-1)~=-1 && Locate(Index2)==-1 &&  Asset(Index2-1) ~=0          %持续看多，且昨天有股票
            
            Volume(Index2)=-Asset(Index2-1);
            Amount(Index2)=Asset(Index2-1)*Data(MALength1+Index2-1,2);
            
        elseif Locate(Index2-1)==1 && Locate(Index2)~=-1 && Asset(Index2-1) ~=0           % 昨天看多，今天看空，且昨天有股票
            Asset(Index2) = Asset(Index2-1);
            Amount(Index2) = Asset(Index2)*Data(MALength1+Index2-1,2);
        else
            Amount(Index2)=Amount(Index2-1);                                       % 持续看空
        end
    end
    Data = [Data(MALength1:end,:),Data_ma,];
    
    
elseif MALength1~=MALength2
    if MALength1>MALength2
        Temp=MALength2;
        MALength2=MALength1;
        MALength1=Temp;
    end
    
    Data_ma1=ma(Data(:,2),MALength1);
    Data_ma2=ma(Data(:,2),MALength2);
    len=min(length(Data_ma1),length(Data_ma2));
    Data_ma1 = Data_ma1(end-len+1:end);
    
    
    Locate=zeros(len,1);
    Volume=zeros(len,1);%交易时间以及交易量
    Asset=zeros(len,1);%持有股票数量
    Amount=zeros(len,1);%资产值
    
    Locate((Data_ma1>Data_ma2)) = 1;
    Locate((Data_ma1<Data_ma2)) = -1;
    
    Amount(1)=initAsset;
    
    for Index2=2:len
        if Locate(Index2-1)~=1&&Locate(Index2)==1
            Volume(Index2)=Amount(Index2-1)/Data(MALength2+Index2-1,2);
            Amount(Index2)=Amount(Index2-1);
            Asset(Index2)=Volume(Index2);
            
        elseif Locate(Index2-1)~=-1 && Locate(Index2)==-1 &&  Asset(Index2-1) ~=0
            Volume(Index2)=-Asset(Index2-1);
            Amount(Index2)=Asset(Index2-1)*Data(MALength2+Index2-1,2);
            
        elseif Locate(Index2-1)==1 && Locate(Index2)==1 &&  Asset(Index2-1) ~=0
            Asset(Index2) = Asset(Index2-1);
            Amount(Index2) = Asset(Index2)*Data(MALength2+Index2-1,2);
        else
            Amount(Index2)=Amount(Index2-1);
        end
    end
    Data = [Data(MALength2:end,:),Data_ma1,Data_ma2];
end

Data=[Data,Locate,Volume,Asset,Amount];

%价格，买卖时点，交易量，仓位，资产值序列
Data2 = Data(Volume~=0,:);
if isempty(Data2)
    output1 = [];
    output2 = [];
    output3 = [];
    return;
end
if  Data2(1,1) ~= Data(1,1)
    Data2 =  [Data(1,:);Data2];
end
if Data2(end,1) ~= Data(end,1)
    Data2 = [Data2;Data(end,:)];
end
Data = Data2;

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


    function output=ma(Data,N)
        
        if size(Data,1)<N
            error('Data is not enough!');
        else
            output=zeros(size(Data,1)-N+1,1);
            for i=1:N
                output=Data(i:end-N+i)+output;
            end
            output=output/N;
        end
    end

    end


