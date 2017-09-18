function ihist( ts )
%IHIST hist ts，并在图上标出分位数
% @luhuaibao
% 2014.6.3
 
hist(ts,100);
 
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 
prct = prctile(ts,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 




end

