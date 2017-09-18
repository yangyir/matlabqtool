%[output1,output2,output3] = MACDStrategy2('2009-06-01','2012-06-01','000001.SZ',12,26,9,100000)
function [output1,output2,output3] =MACDStrategy(StartDate,EndDate,Security,short,long,mlen,initAsset)

%  ����Ĭ�ϲ���
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

% �����Ƿ��Cache�ж�ȡ���ݣ�1Ϊ��Cache�ж�ȡ���ݣ�0Ϊ�����������ݡ�
downloadmark=0;
initStocks=0;
% ��ȡ������
tradingdate = DH_D_TR_MarketTradingday(1,StartDate,EndDate);
tradingdate_num = datenum(tradingdate);
% ������Ӧ����������ǰ��Ȩ�����̼�
if downloadmark == 1
    Data1 = readfromcache_backtest(Security,StartDate,EndDate);
    Loc = bsxfun(@eq,Data1(:,1),tradingdate_num');
    Data = Data1(logical(sum(Loc,2)),[1,5]);
else
    Data1 = DH_Q_DQ_Stock(Security,cellstr(tradingdate),'Close',3);
    Data = [tradingdate_num,Data1];
end
Data(isnan(Data(:,2)),:)=[];

% ������ʼ�պͽ�ֹ�ռ�MACD���ָ��DIFF DEA�Ѿ�MACD������
[diff,dea,macdval]=M_MACD(Data(:,2),short,long,mlen);
%Locate=zeros(length(macdval),1);
Data=Data(end-length(diff)+1:end,:);
Volume=zeros(length(macdval),1);%����ʱ���Լ�������
Asset=zeros(length(macdval),1);%���й�Ʊ����
Amount=zeros(length(macdval),1);%���ʲ�ֵ
Asset1=zeros(length(macdval),1);%�����ֽ���

Amount(1)=initAsset;
Asset1(1)=initAsset;
%  ����ִ��ʱ��֤ȯ���ֽ��������������Լ��ʲ���ֵ���������
for index=2:length(macdval)
% �� ����㣨DIFF����ͻ��DEA��DIFF��DEA��Ϊ��,�����ʽ���Ϊ����
    if diff(index)>diff(index-1) && diff(index)>dea(index) && diff(index-1)<dea(index-1) && diff(index)>0 && dea(index)>0 && Asset1(index-1)>0
        Volume(index)=Asset1(index-1)/Data(index,2);
        Asset1(index)=0;
        Amount(index)=Amount(index-1);
        Asset(index)=Volume(index);
%��  ������ ��DIFF���µ���DEA��DIFF��DEA��Ϊ��������֤ȯ��Ϊ����
    elseif diff(index)<diff(index-1) && diff(index)<dea(index) && diff(index-1)>dea(index-1) && diff(index)<0 &&dea(index)<0  && Asset(index-1)>0
         Volume(index)=-Asset(index-1);
         Asset1(index)=Asset(index-1)*Data(index,2);
         Amount(index)=Asset(index-1)*Data(index,2);
    else
%   ���е�
        if  Asset(index-1)>0
            Asset(index)=Asset(index-1);
            Asset1(index)=Asset1(index-1);
            Amount(index)=Asset(index-1)*Data(index,2);
        else
%    �ղֵ�
            Asset1(index)=Asset1(index-1);
            
            Amount(index)=Amount(index-1);
        end
       
    end
end
Data=[Data,Volume,Asset,Amount];

% ���ò����޽��������output1��output2��output3��Ϊ��
Data1=Data(Volume~=0,:);
if(isempty(Data1))
    output1 = [];
    output2 = [];
    output3= [];
    return;
end

% ���ʱӦ�����պͽ�ֹ��
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

% MACD�и�ָ��DIFF��DEA�Լ�MACD���ļ���
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

