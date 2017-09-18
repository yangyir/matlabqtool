function ihist( ts )
%IHIST hist ts������ͼ�ϱ����λ��
% @luhuaibao
% 2014.6.3
 
hist(ts,100);
 
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 
prct = prctile(ts,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 




end

