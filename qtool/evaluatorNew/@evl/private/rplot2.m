function [] = rplot2(Date1, nav1, Date2, nav2)
% 给出两列基金净值和数值格式的时间，做出净值对比图 
% ----------------------------------------------
% 唐一鑫 08/01/2015
h = plot(Date1, nav1, Date2, nav2);
grid on
set(h(1),'color','r','linewidth',2);
set(h(2),'color','b','linewidth',2);

set(gca,'XTick',29)
datetick('x',29);

set(gca,'xlim',[min(Date1(1),Date2(1)),max(Date1(end),Date2(end))]);

title('净值-收益 曲线');
xlabel('时间');
ylabel(gca,'收益')
legend('股票1','股票2','location','northwest')  
end
