function [] = rplot2b(nav1,Date1,nav2,Date2)
% 给出两列基金净值和数值格式的时间，做出两幅上下时间对齐的净值-收益对比图
% --------------------------------------
% 唐一鑫  08/01/2015

subplot(2,1,1)
yield1 = nav1(2:end)./nav1(1:end-1)-1;
[ax,h1,h2] = plotyy(Date1(2:end),yield1,Date1, nav1,'bar','plot');
grid on
set(h2,'color','r','linewidth',3);
set(h1,'BarWidth',0.5);
set(ax(2),'XTick',29)
set(ax(1),'XTick',29)
datetick('x',29);
set(ax(1),'xlim',[min(Date1(1),Date2(1)),max(Date1(end),Date2(end))]);
set(ax(2),'xlim',[min(Date1(1),Date2(1)),max(Date1(end),Date2(end))]);
title('净值-收益 曲线');
xlabel('时间');
ylabel(ax(1),'收益')
ylabel(ax(2),'净值')
legend('收益','净值','location','northwest')

subplot(2,1,2)
yield2 = nav2(2:end)./nav2(1:end-1)-1;
[ax,h1,h2] = plotyy(Date2(2:end),yield2,Date2, nav2,'bar','plot');
grid on
set(h2,'color','r','linewidth',3);
set(h1,'BarWidth',0.5);
set(ax(2),'XTick',29)
set(ax(1),'XTick',29)
datetick('x',29);
set(ax(1),'xlim',[min(Date1(1),Date2(1)),max(Date1(end),Date2(end))]);
set(ax(2),'xlim',[min(Date1(1),Date2(1)),max(Date1(end),Date2(end))]);
title('净值-收益 曲线');
xlabel('时间');
ylabel(ax(1),'收益')
ylabel(ax(2),'净值')
legend('收益','净值','location','northwest')
end