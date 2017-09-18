% [output1,output2,output3] = MA('2010-01-01','2013-01-17','000002.SZ',5,10,100000)

 function [output1,output2,output3]=MA(StartDate,EndDate,Security,MALength1,MALength2,initAsset)

% �����Securityֻ��Ʊ��ծȯ���߽��������׵Ļ��𡣲�����Ϊ��֤ͬȯչ����ʽ��ͬ����������
% ֻ���ǵ���һ��ETF���𡣲��������ղ�����

load('MAdata');
if nargin<5
    initAsset = 0;
end
%  downloadmark Ϊ0������ʵʱ���ط�ʽ�������ݣ�downloadmarkΪ1ʱ�����ö�Cache��ʽ���ѻ�չ��ģʽ��
downloadmark = 0;
initStocks = 0;

% ��һ�������ǽ�������Ҫ����ȡ��


tradingdate = DH_D_TR_MarketTradingday(1,StartDate,EndDate);%����ʹ�õĽ��������Ϻ�֤ȯ�������������ڣ�����м����ڻ�������Ҫ����һЩ����
tradingdate_num = datenum(tradingdate);

if downloadmark == 1 
    Data1 = readfromcache_backtest(Security,StartDate,EndDate);
    Loc = bsxfun(@eq,Data1(:,1),tradingdate_num');
    Data = Data1(logical(sum(Loc,2)),[1,5]);
else
    Data1 = DH_Q_DQ_Stock(Security,cellstr(tradingdate),'Close',3);
    Data = [tradingdate_num,Data1];
end

Data(isnan(Data(:,2)),:)=[];    % ��仰û������

if MALength1==MALength2              % ֻ��һ������
    
    Data_ma=ma(Data(:,2),MALength1);     % ��������
    Locate=zeros(length(Data_ma),1);     %
    Volume=zeros(length(Data_ma),1);%����ʱ���Լ�������
    Asset=zeros(length(Data_ma),1);%���й�Ʊ����
    Amount=zeros(length(Data_ma),1);%�ʲ�ֵ
    
    Locate((Data_ma>Data(MALength1:end,2)))=1;
    Locate((Data_ma<Data(MALength1:end,2)))=-1;
    Amount(1)=initAsset;
    
    for Index2=2:length(Data_ma)
        if Locate(Index2-1)~=1&&Locate(Index2)==1   % ���쿴�գ����쿴��
            Volume(Index2)=Amount(Index2-1)/Data(MALength1+Index2-1,2);     %�����Ʊ��ȫ�ֽ���
            Amount(Index2)=Amount(Index2-1);                                %������ʲ���ֵ = ������ʲ�
            Asset(Index2)=Volume(Index2);                                       
            
        elseif Locate(Index2-1)~=-1 && Locate(Index2)==-1 &&  Asset(Index2-1) ~=0          %�������࣬�������й�Ʊ
            
            Volume(Index2)=-Asset(Index2-1);
            Amount(Index2)=Asset(Index2-1)*Data(MALength1+Index2-1,2);
            
        elseif Locate(Index2-1)==1 && Locate(Index2)~=-1 && Asset(Index2-1) ~=0           % ���쿴�࣬���쿴�գ��������й�Ʊ
            Asset(Index2) = Asset(Index2-1);
            Amount(Index2) = Asset(Index2)*Data(MALength1+Index2-1,2);
        else
            Amount(Index2)=Amount(Index2-1);                                       % ��������
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
    Volume=zeros(len,1);%����ʱ���Լ�������
    Asset=zeros(len,1);%���й�Ʊ����
    Amount=zeros(len,1);%�ʲ�ֵ
    
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

%�۸�����ʱ�㣬����������λ���ʲ�ֵ����
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


