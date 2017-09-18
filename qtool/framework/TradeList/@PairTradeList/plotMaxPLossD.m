function [ ] = plotMaxPLossD(obj)
%PLOTMAXPLOSS Summary of this function goes here
%   Detailed explanation goes here

% ÅËÆä³¬£¬20140709£¬V1.0

obj.prune();
pnl = obj.data(:,obj.pnlI);
maxLoss = obj.data(:,obj.maxLossI);
pnl = pnl(1:2:obj.rcdNum);
maxLoss = maxLoss(1:2:obj.rcdNum);
maxLoss = abs(maxLoss);

winIdx = pnl>0;
losIdx = pnl<=0;

winF = plot(maxLoss(winIdx),pnl(winIdx),'g^');
set(winF,'MarkerFaceColor','g');
hold on;
losF = plot(maxLoss(losIdx),-pnl(losIdx),'rv');
set(losF,'MarkerFaceColor','r');

set(gca,'Box','Off');
ylabel('PNL');
xlabel('Max Potential Loss');
title('Distribution of Max Potential Loss');
hL = legend([winF,losF],'Profit Trade','Loss Trade','Location','NorthEast');
set(hL,'FontSize',8);
legend('BoxOff');

end

