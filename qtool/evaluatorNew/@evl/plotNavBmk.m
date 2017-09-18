function [hfig] = plotNavBmk(nav,benchmark)
% ���������ڻ���nav��benchmark����֮��Ĳ���
% function [hfig] = plotNavBmk(nav,benchmark)
%   nav:����Ʊ��ֵ
%   benchmark: ѡȡ��׼��ֵ
%-------------------------------------
% tangyixin,20150513  
% �̸գ�20150525��Ԥ�����н�nav��benchmark��һ��

%% Ԥ����


% ��һ����nav
nav = nav / nav(1);

% ��һ����benchmark
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



legend('��ֵ','nav','benchmark','location','northwest') ;
legend('boxoff');
title(['Nav & Benchmark']);
end
