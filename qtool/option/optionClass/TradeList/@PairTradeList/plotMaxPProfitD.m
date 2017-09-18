function [ ] = plotMaxPProfitD( obj )
%PLOTMAXPPROFIT Summary of this function goes here
%   Detailed explanation goes here

% ÅËÆä³¬£¬20140709£¬V1.0
obj.prune();
pnl = obj.data(:,obj.pnlI);
maxProfit = obj.data(:,obj.maxProfitI);
pnl = pnl(1:2:obj.rcdNum);
maxProfit = maxProfit(1:2:obj.rcdNum);


winIdx = pnl>0;
losIdx = pnl<=0;

winF = plot(maxProfit(winIdx),pnl(winIdx),'g^');
set(winF,'MarkerFaceColor','g');
hold on;
losF = plot(maxProfit(losIdx),-pnl(losIdx),'rv');
set(losF,'MarkerFaceColor','r');

set(gca,'Box','Off');
ylabel('PNL');
xlabel('Max Potential Profit');
title('Distribution of Max Potential Profit');
hL = legend([winF,losF],'Profit Trade','Loss Trade','Location','NorthEast');
set(hL,'FontSize',8);
legend('BoxOff');

end

