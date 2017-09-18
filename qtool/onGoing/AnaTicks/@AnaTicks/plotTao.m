function  plotTao( tao,minSpread )
% version 1.0, luhuaibao
% 2014.5.29
% �����plot tao����time-after-order
% inputs:
% tao:
%       time-after-order, �µ���Ǳ�ڵȴ�ʱ�䣻
%       tao.labels,  ���ݾ����ǩ
%       tao.values,  ���ݾ���
% taoΪ�����µ���ʽ�£����鿴���ɽ���ȴ�ʱ��
% minSpread
%       �����ֲ�ʱ����������

if ~exist('minSpread','var')
    minSpread = 0 ; 
end ; 


avg = nanmean(tao.values) ;
vstd = nanstd(tao.values) ;

s1 = ['�м���: ', '�ɽ�ƽ���ȴ�ʱ��/s, ',num2str(avg(1)), ';    �ȴ�ʱ���׼��,  ', num2str(vstd(1))];
s2 = ['�м���: ', '�ɽ�ƽ���ȴ�ʱ��/s, ',num2str(avg(2)), ';    �ȴ�ʱ���׼��,  ', num2str(vstd(2))];
s3 = ['�޼���, ����',num2str(tao.yields),' : ', '�ɽ�ƽ���ȴ�ʱ��/s, ',num2str(avg(3)), ';    �ȴ�ʱ���׼��,  ', num2str(vstd(3))];
s4 = ['�޼���, ����',num2str(tao.yields),' : ', '�ɽ�ƽ���ȴ�ʱ��/s, ',num2str(avg(4)), ';    �ȴ�ʱ���׼��,  ', num2str(vstd(4))];

s5 = ['�޼���, ����',num2str(tao.yields),'   ��������',num2str(minSpread),' : ', '�ɽ�ƽ���ȴ�ʱ��/s, ',num2str(avg(3)), ';    �ȴ�ʱ���׼��,  ', num2str(vstd(3))]; 
s6 = ['�޼���, ����',num2str(tao.yields),'   ��������',num2str(minSpread),' : ', '�ɽ�ƽ���ȴ�ʱ��/s, ',num2str(avg(4)), ';    �ȴ�ʱ���׼��,  ', num2str(vstd(4))];

disp('�����ֲ�');
disp(s1);
disp(s2);
disp(s3);
disp(s4);
disp('�������ֲ�');
disp(s5);
disp(s6);

 
 
%% plot
figure() 
r = tao.values(:,1) ; 
subplot(2,2,1)
hist(r,100);
title(s1,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 



subplot(2,2,2)
hist(tao.values(:,2),100);
title(s2,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ;  
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 


subplot(2,2,3)
hist(tao.values(:,3),100);
title(s3,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 



subplot(2,2,4)
hist(tao.values(:,4),100);
title(s4,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 



%% ����ɸѡ
r = tao.values(:,3) ; 
ab = tao.ticks.askP(:,1) - tao.ticks.bidP(:,1);
ab = ab(1:tao.ticks.latest);
w = r(ab>minSpread) ; 
figure() 
subplot(2,1,1)
hist(w,100);
title(s5,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 


disp(s5);


r = tao.values(:,4) ; 
w = r(ab>minSpread) ; 
subplot(2,1,2)
hist(w,100);
title(s6,'fontsize',7);
set(gca,'fontsize',7) ; 
x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*2 ; 
y = y(1)+(y(2) - y(1))/4*2 ; 
prct = prctile(r,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 


disp(s6);


end

