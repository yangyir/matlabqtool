function [ newBars ] = linkBars( bars1,bars2 )
if ~strcmp(bars1.code,bars2.code)
    error('Not the same contract!');
elseif ~strcmp(bars1.type,bars2.type)
    error('Not the same species!');
end

if bars1.time(1)>bars2.time(end)
    head = bars2;
    tail = bars1;
elseif bars1.time(end)<bars2.time(1)
    head = bars1;
    tail = bars2;
end
%%
newBars = Bars;
newBars.code = head.code;
newBars.type = head.type;
newBars.time = [head.time;tail.time];
newBars.open = [head.open;tail.open];
newBars.high = [head.high;tail.high];
newBars.low = [head.low;tail.low];
newBars.close = [head.close;tail.close];
newBars.vwap = [head.vwap;tail.vwap];
newBars.volume = [head.volume;tail.volume];
newBars.amount = [head.amount;tail.amount];
newBars.openInterest = [head.openInterest;tail.openInterest];
    
end

