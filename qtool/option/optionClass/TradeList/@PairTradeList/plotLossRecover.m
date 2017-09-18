function [  ] = plotLossRecover( obj )
%PLOTMAXPLOSS Summary of this function goes here
%   Detailed explanation goes here

% ≈À∆‰≥¨£¨20140709£¨V1.0
obj.prune();
pnl = obj.data(:,obj.pnlI);
maxLoss = obj.data(:,obj.maxLossI);
pnl = pnl(1:2:obj.rcdNum);
maxLoss = maxLoss(1:2:obj.rcdNum);

h = bar([maxLoss,pnl-maxLoss],'stacked');
set(h(1),'FaceColor','c','EdgeColor','none');
set(h(2),'FaceColor','g','EdgeColor','none');

set(gca,'Box','Off');
xlabel('TradeNo');
ylabel('PNL');
title('Trade Loss Recover');
hL = legend(h,{'realized pnl','loss recover'},'Location','NorthEast');
set(hL,'FontSize',8);
legend('BoxOff');

end

