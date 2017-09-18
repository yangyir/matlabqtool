function [ ] = plotTradePnl( obj )
%PLOTTRADEPNL Summary of this function goes here
%   Detailed explanation goes here

% ≈À∆‰≥¨£¨20140709£¨V1.0

obj.prune();
pnl = obj.data(:,obj.pnlI);
pnl = pnl(1:2:obj.rcdNum);

h = bar(pnl);
title('PNL by Trade');
xlabel('Trade No');
ylabel('PNL');
set(h,'FaceColor','c');
set(h,'EdgeColor','none');
set(gca,'Box','Off');

end

