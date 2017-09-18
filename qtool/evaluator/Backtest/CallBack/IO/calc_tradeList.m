function [ tradeList ] = calc_tradeList( indBuy,indSell,indSellShort,indBuy2Cover,account,time )
%% 
indBuy = indBuy{1};
indSell = indSell{1};
indSellShort = indSellShort{1};
indBuy2Cover = indBuy2Cover{1};

if any(indBuy.*indSell.*indSellShort.*indBuy2Cover)
    error('trade order conflict!');
end

indEnter = indBuy+indSellShort;
indExit = indSell+indBuy2Cover;

enterIndex = find(indEnter);
exitIndex = find(indExit);

numEnter = length(enterIndex);
numExit = length(exitIndex);

if numEnter~=numExit
    if numEnter-numExit == 1
        enterIndex = enterIndex(1:end-1);
    else
        error('signal error!');
    end
end

tradeRet = account(exitIndex)./account(enterIndex-1)-1;
tradeFlag = indEnter(enterIndex);
startTime = time(enterIndex);
endTime = time(exitIndex);

tradeList = [tradeRet,tradeFlag,startTime,endTime];

    


end

