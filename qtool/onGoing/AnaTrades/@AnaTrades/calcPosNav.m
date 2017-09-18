function [ pos, nav ] = calcPosNav( tick, list )
%CALCPOSNAV Summary of this function goes here
%   Detailed explanation goes here

numTick = tick.latest;
numTrade = list.latest;
pos = zeros(numTick,1);
nav = zeros(numTick,1);

tradeNo = 1;
for i = 2:numTick
    if i<list.tick(tradeNo)
        pos(i) = pos(i-1);
        nav(i) = nav(i-1)+ pos(i)*(tick.last(i)-tick.last(i-1))*300;
    else
        nav(i) = nav(i-1)+ pos(i-1)*(tick.last(i)-tick.last(i-1))*300;
        nav(i) = nav(i) + list.volume(tradeNo)*list.direction(tradeNo)*(tick.last(i)-list.price(tradeNo))*300;
        
        pos(i) = pos(i-1)+list.volume(tradeNo)*list.direction(tradeNo);
        tradeNo = tradeNo+1;
        if(tradeNo>numTrade)
            break;
        end
    end
end

if i<numTick
    pos(i+1:numTick) = pos(i);
    nav(i+1:numTick) = nav(i)+ pos(i)*(tick.last(i+1:numTick)-tick.last(i))*300;
end


end



