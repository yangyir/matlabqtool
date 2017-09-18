function  ts1_ts2_spread( ts1, ts2 )
%TS1_TS2_SPREAD     ��ʱ�����У�ts1, ts2, �������᣻���ử���ߵĲ�
% ��һ��ͨ���ԣ��ʲ�����private��
% @luhuaibao
% 2014.6.3

n1 = length(ts1);
n2 = length(ts2);
if n1~=n2
    error('�����г��Ȳ��ȣ�');
end ; 


 
x = (1:n1)';
y1 = ts1;
y2 = ts2 ;
y3 = y1-y2 ; 

setplot.plottype = [{'plot'},{'bar'}]; 
setplot.legend = [{'ts1'},{'ts2'},{'�۲�'} ]; 
setplot.title = '�������Ƽ���ֵ'; 
 

plotdata.x = x ; 
plotdata.y1 =  [y1,y2]  ; 
plotdata.y2 = y3 ; 
iplot.plotYY(plotdata, setplot);
 

x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 


x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 
prct = prctile(y3,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 

 


end

