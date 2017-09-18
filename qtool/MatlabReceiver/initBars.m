function [ barObj ] = initBars( numMark )
%INITBARS initialize an empty Bars object
%%
barObj = Bars;
barObj.time          = zeros(numMark,1);
barObj.open          = zeros(numMark,1);
barObj.close         = zeros(numMark,1);
barObj.high          = zeros(numMark,1);
barObj.low           = zeros(numMark,1);
barObj.volume        = zeros(numMark,1);
barObj.amount        = zeros(numMark,1);
barObj.openInterest  = zeros(numMark,1);
end

