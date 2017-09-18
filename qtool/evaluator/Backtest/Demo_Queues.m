clear;
clc;
tic
newQ = SellStopQueue();
bars = importdata('barSample.mat');
for i = 1:length(bars.close)
    order.time = bars.time(i);
    order.price = bars.vwap(i);
    order.volume = 1;
    order.liquidate = 0;
    if randsrc()==1
       newQ.add(order);
    elseif ~newQ.orderEmpty()
       newQ.pop();
    end
end
toc