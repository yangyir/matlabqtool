function [ tradeList ] = calc_tradeList_v2( signal,account,time,bars,configure)

lag = configure.lag;
% 信号向后顺延lag个单位
signal  =  [zeros(lag,1); signal(1:end - lag)];

buy_num = find(signal(lag:end-1)<=0&signal(lag+1:end)>0) + lag;
sell_num = find(signal(lag:end-1)>0&signal(lag+1:end)<=0) + lag-1;
buyshort_num = find(signal(lag:end-1)>=0&signal(lag+1:end)<0) + lag;
sellshory_num = find(signal(lag:end-1)<0&signal(lag+1:end)>=0) + lag-1;

enterIndex = sort([buy_num;buyshort_num]);
exitIndex = sort([sell_num;sellshory_num]);

indEnter = zeros(size(signal,1),1);
indExit = zeros(size(signal,1),1);
indEnter(buy_num) = 1;
indEnter(buyshort_num) = -1;
indExit(sellshory_num) = 1;
indExit(sell_num) = -1;

%%
tradeRet = account(exitIndex-1)./account(enterIndex-1)-1;
tradeFlag = indEnter(enterIndex);
startTime = time(enterIndex);
endTime = time(exitIndex);

hand = zeros(length(tradeRet),1);
for i = 1:length(tradeRet)
    hand(i) = max(abs(signal(enterIndex(i):exitIndex(i))));
end
transaction=zeros(length(tradeRet),1);
for i=1:length(tradeRet)
    temp=[0;signal(enterIndex(i):exitIndex(i))];
    if tradeFlag(i)==1 
    transaction(i)=length(find(temp(2:end)>temp(1:end-1)));  
    else
    transaction(i)=length(find(temp(2:end)<temp(1:end-1)));
    end 
end
tradeList = [tradeRet,tradeFlag,startTime,endTime,enterIndex,exitIndex,transaction,hand];
end

