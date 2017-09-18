%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于Main中主体的价格图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_main_m(f,main)

h = axes('parent',f,'position',[0.03,0.08,0.78,0.77]);
hold on;
c =  [0,1,1;1,0,1;1,0.3,0.3;0,1,0.4];
[h_a,a1,a2] = plotyy(main.marketdata{1}(:,1),main.marketdata{1}(:,5),main.benchmarkprice(:,1),main.benchmarkprice(:,2));
set(a1,'color',c(1,:));
set(h_a(2),'xticklabel','','ygrid','on');
set(a2,'color',c(2,:));
 
if length(main.marketdata)>1
    for index = 2:length(main.marketdata)
        data = main.marketdata{index}(:,[1,5]);
        p = plot(h_a(1),data(:,1),data(:,2));
        set(p,'color',c(index+1,:));
        axis(h_a(1),'auto');
    end
end
ymax = 0;
ymin = 0;
for index3 = 1:length(main.marketdata)
    ymax = max(ymax,max(main.marketdata{index3}(:,5)));
    ymin = min(ymin,min(main.marketdata{index3}(:,5)));
end
tick = linspace(ymin,ymax,5);
tick = floor(tick);
set(h_a(1),'ytick',tick);
for index2 = 1:length(main.marketdata)
    data = main.marketdata{index2}(:,[1,5]);
    data_b = data(main.close_buy{index2},:);
    plot(h_a(1),data_b(:,1),data_b(:,2),'r^');
    data_s = data(main.close_sell{index2},:);
    plot(h_a(1),data_s(:,1),data_s(:,2),'g+');   
end

legend(main.secucode);
hold off;

% x轴label转换成日期
datetick('x',29,'keepticks','keeplimits');
title('价格图');

end