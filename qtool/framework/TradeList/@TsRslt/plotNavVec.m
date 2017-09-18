function [ ] = plotNavVec(obj )
%PLOTNAVVEC Summary of this function goes here
%   Detailed explanation goes here


nav = obj.cumPnlVec+obj.initNav;
hNav = plot(nav);
xlabel('Time Series No');
ylabel('Cumulative PNL');
title('Cumulative PNL as a Time Series');
set(hNav,'color',[1,0,0],'LineWidth',2);
set(gca,'Box','off');

txtStr1 = sprintf('startT: %s\n', datestr(obj.time(1),'yy/mm/dd HH:MM'));
txtStr2 = sprintf('endT:   %s\n', datestr(obj.time(end),'yy/mm/dd HH:MM'));
txtStr3 = sprintf('SF:     %s\n', obj.timeFrequency);
txtStr4 = sprintf('AnnSharpe: %2.2f\n',obj.RNR.sharpe);
txtStr5 = sprintf('CumPNL:    %0.2f\n',obj.cumPnlVec(end));
txtStr6 = sprintf('MaxDD:     %2.2f%%%',obj.RNR.maxDD*100);
txtStr = [txtStr1,txtStr2,txtStr3,txtStr4,txtStr5,txtStr6];
navHigh = max(nav);
navLow = min(nav);
navRange = navHigh-navLow;
text(length(obj.time)/100,navHigh-navRange/5,txtStr,'FontName','FixedWidth');

end

