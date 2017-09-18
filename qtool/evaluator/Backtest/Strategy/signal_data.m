 function [output1,output2,output3]=signal_data(position,marketdata,initAsset)

 
%  本函数不是交易信号的发生器，而只是按照每天的交易信号，给出cj_bakctest的输入参数。
%  本函数的仓位信号，为多，空，平。不能产生0.5成仓这样的仓位。
%  position为简单的（1,0,-1)型，其中1表示为持多仓，0为无仓，-1为开空仓。其中position必须包含所有交易日，即和将来计算净值时的天数一样。

%  每次交易的数量=可用资金/价格/100 ，再fix

%  marketdata为相关股票的交易数据。 在计算中一旦发生交易，marketdata为交易价格,所以可以不等于收盘价。
    
    
  
    Volume=zeros(length(position),1);    %交易时间以及交易量。
    Cash=zeros(length(position),1);    %资产值
    
    Cash(1)=initAsset;
   
    buydata=marketdata(:,2);   % 买入价格为open.
   % buydata=marketdata(:,2);   % 买入价格为open.
    
    for j=2:length(position)
        if position(j-1)==0 && position(j)==1 &&   Cash(j-1)>0                 % 平————————多
            Volume(j)=fix(Cash(j-1)/buydata(j)/100);                                    %购入股票，全仓进出，现金减少
            Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100;                                %今天的现金= 昨天的现金-今天买入的之处
            
        elseif position(j-1)==0 &&position(j)==-1                              % 平————————空          
            Volume(j)=-fix(Cash(j-1)/buydata(j)/100);                                    %卖空股票，全仓进出，收获现金
            Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100; 
            
        elseif  position(j-1)==1 &&position(j)==-1                             % 空----------------多（持空仓，直接转为持多仓）
             Volume(j)=fix(Cash(j-1)/buydata(j)/100)-Volume(j-1);                         %直接的从持有空仓，变为持有多仓。  
             Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100; 
            
            
       elseif  position(j-1)==1 &&position(j)==-1                             %  多----------------空（持多仓，直接转为持空仓）    
             Volume(j)=-fix(Cash(j-1)/buydata(j)/100)-Volume(j-1);                         %直接的从持有多仓，变为持有空仓。  
             Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100; 
                 
        elseif position(j-1)==position(j)                                        % 维持多仓，空仓和平仓
            
            Volume(j)=Volume(j-1);
            Cash(j)= Cash(j-1);
   ;                                       
        end
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