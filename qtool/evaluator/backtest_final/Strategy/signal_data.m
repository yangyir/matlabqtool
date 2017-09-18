 function [output1,output2,output3]=signal_data(position,marketdata,initAsset)

 
%  ���������ǽ����źŵķ���������ֻ�ǰ���ÿ��Ľ����źţ�����cj_bakctest�����������
%  �������Ĳ�λ�źţ�Ϊ�࣬�գ�ƽ�����ܲ���0.5�ɲ������Ĳ�λ��
%  positionΪ�򵥵ģ�1,0,-1)�ͣ�����1��ʾΪ�ֶ�֣�0Ϊ�޲֣�-1Ϊ���ղ֡�����position����������н����գ����ͽ������㾻ֵʱ������һ����

%  ÿ�ν��׵�����=�����ʽ�/�۸�/100 ����fix

%  marketdataΪ��ع�Ʊ�Ľ������ݡ� �ڼ�����һ���������ף�marketdataΪ���׼۸�,���Կ��Բ��������̼ۡ�
    
    
  
    Volume=zeros(length(position),1);    %����ʱ���Լ���������
    Cash=zeros(length(position),1);    %�ʲ�ֵ
    
    Cash(1)=initAsset;
   
    buydata=marketdata(:,2);   % ����۸�Ϊopen.
   % buydata=marketdata(:,2);   % ����۸�Ϊopen.
    
    for j=2:length(position)
        if position(j-1)==0 && position(j)==1 &&   Cash(j-1)>0                 % ƽ������������������
            Volume(j)=fix(Cash(j-1)/buydata(j)/100);                                    %�����Ʊ��ȫ�ֽ������ֽ����
            Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100;                                %������ֽ�= ������ֽ�-���������֮��
            
        elseif position(j-1)==0 &&position(j)==-1                              % ƽ������������������          
            Volume(j)=-fix(Cash(j-1)/buydata(j)/100);                                    %���չ�Ʊ��ȫ�ֽ������ջ��ֽ�
            Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100; 
            
        elseif  position(j-1)==1 &&position(j)==-1                             % ��----------------�ࣨ�ֿղ֣�ֱ��תΪ�ֶ�֣�
             Volume(j)=fix(Cash(j-1)/buydata(j)/100)-Volume(j-1);                         %ֱ�ӵĴӳ��пղ֣���Ϊ���ж�֡�  
             Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100; 
            
            
       elseif  position(j-1)==1 &&position(j)==-1                             %  ��----------------�գ��ֶ�֣�ֱ��תΪ�ֿղ֣�    
             Volume(j)=-fix(Cash(j-1)/buydata(j)/100)-Volume(j-1);                         %ֱ�ӵĴӳ��ж�֣���Ϊ���пղ֡�  
             Cash(j)=Cash(j-1)-Volume(j)*buydata(j)*100; 
                 
        elseif position(j-1)==position(j)                                        % ά�ֶ�֣��ղֺ�ƽ��
            
            Volume(j)=Volume(j-1);
            Cash(j)= Cash(j-1);
   ;                                       
        end
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