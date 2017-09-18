function [hfig] = plotNavBmk(nav,benchmark)
% 本函数用于画出nav和benchmark及其之间的差异
% function [hfig] = plotNavBmk(nav,benchmark)
%   nav:　股票净值
%   benchmark: 选取基准净值
%-------------------------------------
% tangyixin,20150513  
% 程刚，20150525，预处理中将nav和benchmark归一化

%% 预处理


% 归一化，nav
nav = nav / nav(1);

% 归一化，benchmark
benchmark = benchmark / benchmark(1);



%% main
b  = benchmark;
L  = length(nav);
t  = nav-b;

hfig = figure;
[ax,h1,h2]=plotyy(1:L,t,[(1:L)',(1:L)'],[nav,b],'bar','plot');



set(ax(2),'xlim',[0,L],'ycolor','r')
set(ax(1),'xlim',[0,L],'ycolor','b')
set(h1,'facecolor','c')
set(ax(1),'ylim',[-range(t),range(t)])
set(h2(1),'color','black','linewidth',1.5)
set(h2(2),'color','red','linewidth',1.5)
set(gca,'Xgrid','on')



legend('差值','nav','benchmark','location','northwest') ;
legend('boxoff');
title(['Nav & Benchmark']);
end
