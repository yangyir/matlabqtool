function [] = plotProfitDrawback( obj )
%PLOTMAXPPROFIT Summary of this function goes here
%   Detailed explanation goes here

% ≈À∆‰≥¨£¨20140709£¨V1.0

obj.prune();
pnl = obj.data(:,obj.pnlI);
maxProfit = obj.data(:,obj.maxProfitI);
pnl = pnl(1:2:obj.rcdNum);
maxProfit = maxProfit(1:2:obj.rcdNum);

h = bar([pnl,maxProfit-pnl],'stacked');
set(h(1),'FaceColor','c','EdgeColor','none');
set(h(2),'FaceColor','r','EdgeColor','none');

set(gca,'Box','Off');
xlabel('TradeNo');
ylabel('PNL');
title('Trade Profit Drawdown');

hL = legend(h,{'realized pnl','profit drawback'},'Location','NorthEast');
set(hL,'FontSize',8);
legend('BoxOff');

end

