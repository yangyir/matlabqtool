function [tradeLists,tradeListh]=calc_tradeList_sv2(signal,account,time,bars,configure,tradeList)
lag = configure.lag;
% �ź����˳��lag����λ
signal  =  [zeros(lag,1); signal(1:end - lag)];
tradeLists=[];
tradeListh=[];
enterIndex=tradeList(:,5);
exitIndex=tradeList(:,6);
tradeFlag=tradeList(:,2);
for i=1:size(tradeList,1)
    temp=[0;signal(enterIndex(i):exitIndex(i));0];
    if tradeFlag(i)==1 
    buymoretime1=find(temp(2:end)>temp(1:end-1));
    buymoretime2=bars.time(buymoretime1+enterIndex(i)-1);%�࿪��ʱ���
    buytocovertime1=find(temp(2:end)<temp(1:end-1));
    buytocovertime2=bars.time(buytocovertime1+enterIndex(i)-1);%��ƽ��ʱ���
    buymorehands1=temp(2:end)-temp(1:end-1);
    buymorehands2=buymorehands1(buymorehands1>0);%ÿ�ζ�Ӳֵ�����
   % buytocoverhands1=temp(2:end)-temp(1:end-1);
    buytocoverhands2=buymorehands1(buymorehands1<0);%ÿ�ζ�ƽ�ֵ�����
    %���ݼӲ�ʱ�㽫����Ƭ��
    tradelisttempb=[];
    for j=1:length(buymorehands2)
        starttime=repmat(buymoretime2(j),buymorehands2(j),1);
        tradeflag=repmat(1,buymorehands2(j),1);
        hands=repmat(1,buymorehands2(j),1);
        tradelisttempb=[tradelisttempb;[tradeflag,starttime, hands]];
    end
    %���ݼ���ʱ�㽫����Ƭ��
    tradelisttemps=[];
    for j=1:length(buytocoverhands2)
        endtime=repmat(buytocovertime2(j),-buytocoverhands2(j),1);
        tradelisttemps=[tradelisttemps;endtime];
    end 
    tradelistfinal1=[tradelisttempb,tradelisttemps];
    %����ÿ������
    tradeRet=[];
    tradeRetAb=[];
    for j=1:size(tradelistfinal1,1)
       tradeRet=[tradeRet;bars.open(find(bars.time==tradelistfinal1(j,4))) /...
           bars.open(find(bars.time==tradelistfinal1(j,2)))-1];
       tradeRetAb=[tradeRetAb;(bars.open(find(bars.time==tradelistfinal1(j,4)))-...
           bars.open(find(bars.time==tradelistfinal1(j,2))))*configure.multiplier];
    end
    tradelistfinal11=[tradeRet,tradelistfinal1(:,1:2),tradelistfinal1(:,4),tradelistfinal1(:,3)...
        ,tradeRetAb]; %��Ϊÿ�ֵ�tradinglist
    tradeListh=[tradeListh;tradelistfinal11];
    
    
    [tradelistfinal2,m]=unique(tradelistfinal1,'rows');
    tradelistfinal3=[m,tradelistfinal2];
    tradelistfinal4=sortrows(tradelistfinal3,1);%����ԭ������������
    sumclass1=tradelistfinal4(:,1);
    sumclass2=[sumclass1(2:end);(size(tradelistfinal1,1)+1)];
    handspers=sumclass2-sumclass1;
    tradelistfinal5=[tradelistfinal2,handspers];
    tradeRetAbs=[];
    tradeRets=[];
    length1=size(tradelistfinal11,1);
    handspers1=[0;handspers(1:end-1)];
    handspers2=cumsum(handspers1);
    handspers3=[handspers2;length1];
    for j=1:(length(handspers3)-1)
     tradeRettemps=sum(tradeRetAb((handspers3(j)+1):handspers3(j+1)));
     tradeRettemps1=mean(tradeRet((handspers3(j)+1):handspers3(j+1)));
     tradeRetAbs=[ tradeRetAbs; tradeRettemps];
     tradeRets=[ tradeRets; tradeRettemps1];    
    end
    %ÿ�ʵı�
    tradelistfinal51=[tradeRets,tradelistfinal5(:,1:2),tradelistfinal5(:,4:5),tradeRetAbs];
    tradeLists=[tradeLists;tradelistfinal51];
    else
    sellshortmoretime1=find(temp(2:end)<temp(1:end-1));
    sellshortmoretime2= bars.time(sellshortmoretime1+enterIndex(i)-1);%�տ��ֵ�ʱ���
    selltime1=find(temp(2:end)>temp(1:end-1));
    selltime2=bars.time(selltime1+enterIndex(i)-1);%��ƽ�ֵ�ʱ���
    sellshortmorehands1=temp(2:end)-temp(1:end-1);
    sellshortmorehands2=sellshortmorehands1(sellshortmorehands1<0);%ÿ�οռӲֵ�����
    %sellhands1=temp(2:end)-temp(1:end-1);
    sellhands2=sellshortmorehands1(sellshortmorehands1>0);%ÿ�οռ��ֵ�����
    %���ݼӲ�ʱ�㽫����Ƭ��
        tradelisttempb=[];
    for j=1:length(sellshortmorehands2)
        starttime=repmat(sellshortmoretime2(j),-sellshortmorehands2(j),1);
        tradeflag=repmat(-1,-sellshortmorehands2(j),1);
        hands=repmat(1,-sellshortmorehands2(j),1);
        tradelisttempb=[tradelisttempb;[tradeflag,starttime, hands]];
    end
    %���ݼ���ʱ�㽫����Ƭ��
     tradelisttemps=[];
    for j=1:length(sellhands2)
        endtime=repmat(selltime2(j),sellhands2(j),1);
        tradelisttemps=[tradelisttemps;endtime];
    end 
    tradelistfinal1=[tradelisttempb,tradelisttemps];
    %����ÿ�ֵ�����
     tradeRet=[];
    tradeRetAb=[];
    for j=1:size(tradelistfinal1,1)
       tradeRet=[tradeRet;1-bars.open(find(bars.time==tradelistfinal1(j,4))) /...
           bars.open(find(bars.time==tradelistfinal1(j,2)))];
       tradeRetAb=[tradeRetAb;(bars.open(find(bars.time==tradelistfinal1(j,2)))-...
           bars.open(find(bars.time==tradelistfinal1(j,4))))*configure.multiplier];
    end
    tradelistfinal11=[tradeRet,tradelistfinal1(:,1:2),tradelistfinal1(:,4),tradelistfinal1(:,3)...
        ,tradeRetAb] ;%��Ϊÿ�ֵ�tradinglist
    tradeListh=[tradeListh;tradelistfinal11];
    [tradelistfinal2,m]=unique(tradelistfinal1,'rows');
    tradelistfinal3=[m,tradelistfinal2];
    tradelistfinal4=sortrows(tradelistfinal3,1);%����ԭ������������
    sumclass1=tradelistfinal4(:,1);
    sumclass2=[sumclass1(2:end);(size(tradelistfinal1,1)+1)];
    handspers=sumclass2-sumclass1;
    tradelistfinal5=[tradelistfinal2,handspers];
    %ÿ��
    tradeRetAbs=[];
    tradeRets=[];
    length1=size(tradelistfinal11,1);
    handspers1=[0;handspers(1:end-1)];
    handspers2=cumsum(handspers1);
    handspers3=[handspers2;length1];
    for j=1:(length(handspers3)-1)
     tradeRettemps=sum(tradeRetAb((handspers3(j)+1):handspers3(j+1)));
     tradeRettemps1=mean(tradeRet((handspers3(j)+1):handspers3(j+1)));
     tradeRetAbs=[ tradeRetAbs; tradeRettemps];
     tradeRets=[ tradeRets; tradeRettemps1];    
    end
    %ÿ�ʵı�
    tradelistfinal51=[tradeRets,tradelistfinal5(:,1:2),tradelistfinal5(:,4:5),tradeRetAbs]; 
    tradeLists=[tradeLists;tradelistfinal51];
    end
    
end
end