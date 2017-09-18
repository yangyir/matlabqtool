function  plotTao( tao,minSpread )
% version 1.0, luhuaibao
% 2014.5.29
% 输出并plot tao，即time-after-order
% inputs:
% tao:
%       time-after-order, 下单后潜在等待时间；
%       tao.labels,  数据矩阵标签
%       tao.values,  数据矩阵
% tao为给定下单方式下，后验看，成交需等待时间
% minSpread
%       条件分布时，进场条件

if ~exist('minSpread','var')
    minSpread = 0 ; 
end ; 


avg = nanmean(tao.values) ;
vstd = nanstd(tao.values) ;

s1 = ['市价买: ', '成交平均等待时间/s, ',num2str(avg(1)), ';    等待时间标准差,  ', num2str(vstd(1))];
s2 = ['市价卖: ', '成交平均等待时间/s, ',num2str(avg(2)), ';    等待时间标准差,  ', num2str(vstd(2))];
s3 = ['限价买, 让利',num2str(tao.yields),' : ', '成交平均等待时间/s, ',num2str(avg(3)), ';    等待时间标准差,  ', num2str(vstd(3))];
s4 = ['限价卖, 让利',num2str(tao.yields),' : ', '成交平均等待时间/s, ',num2str(avg(4)), ';    等待时间标准差,  ', num2str(vstd(4))];

s5 = ['限价买, 让利',num2str(tao.yields),'   进场条件',num2str(minSpread),' : ', '成交平均等待时间/s, ',num2str(avg(3)), ';    等待时间标准差,  ', num2str(vstd(3))]; 
s6 = ['限价卖, 让利',num2str(tao.yields),'   进场条件',num2str(minSpread),' : ', '成交平均等待时间/s, ',num2str(avg(4)), ';    等待时间标准差,  ', num2str(vstd(4))];

disp('条件分布');
disp(s1);
disp(s2);
disp(s3);
disp(s4);
disp('非条件分布');
disp(s5);
disp(s6);

 
 
%% plot
figure() 
r = tao.values(:,1) ; 
subplot(2,2,1)
hist(r,100);
title(s1,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 



subplot(2,2,2)
hist(tao.values(:,2),100);
title(s2,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ;  
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 


subplot(2,2,3)
hist(tao.values(:,3),100);
title(s3,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 



subplot(2,2,4)
hist(tao.values(:,4),100);
title(s4,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 



%% 条件筛选
r = tao.values(:,3) ; 
ab = tao.ticks.askP(:,1) - tao.ticks.bidP(:,1);
ab = ab(1:tao.ticks.latest);
w = r(ab>minSpread) ; 
figure() 
subplot(2,1,1)
hist(w,100);
title(s5,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 


disp(s5);


r = tao.values(:,4) ; 
w = r(ab>minSpread) ; 
subplot(2,1,2)
hist(w,100);
title(s6,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 


disp(s6);


end

