function [ sliceQuote ] = packBar( tickArr, startP, numTick,sliceQuote,sliceInd)
%%
% tickArr contains one day's tick quote available
% startP is the index of the starting tick of the slice
% numTick is the number of ticks in the slice
%%
endP = startP+numTick-1;

switch class(sliceQuote)
    case 'double'
        sliceQuote(sliceInd,1) = floor(tickArr(startP,1)/100000);
        sliceQuote(sliceInd,2) = tickArr(startP,2);
        sliceQuote(sliceInd,3) = tickArr(endP,2);
        sliceQuote(sliceInd,4) = max(tickArr(startP:endP,2));
        sliceQuote(sliceInd,5) = min(tickArr(startP:endP,2));
        sliceQuote(sliceInd,6) = tickArr(endP,5)-tickArr(startP,5);
        sliceQuote(sliceInd,7) = tickArr(endP,6)-tickArr(startP,6);
        sliceQuote(sliceInd,8) = round(nanmean(tickArr(startP:endP,7)));
        sliceQuote(sliceInd,9) = numTick;
    case 'Bars'
        currTime                = clock; 
        currTime(4)             = floor(tickArr(startP,1)/10000000);
        currTime(5)             = floor(tickArr(startP,1)/100000)-currTime(4)*100;
        currTime(6)             = mod(floor(tickArr(startP,1)/1000),100);
        sliceQuote.time         = datenum(currTime);
        
        sliceQuote.open         = tickArr(startP,2);
        sliceQuote.close        = tickArr(endP,2);
        sliceQuote.high         = max(tickArr(startP:endP,2));
        sliceQuote.low          = min(tickArr(startP:endP,2));
        sliceQuote.volume       = tickArr(endP,5)-tickArr(startP,5);
        sliceQuote.amount       = tickArr(endP,6)-tickArr(startP,6);
        sliceQuote.openInterest = round(nanmean(tickArr(startP:endP,7)));
end

end