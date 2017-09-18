function  ts1_ts2_spread( ts1, ts2 )
%TS1_TS2_SPREAD     两时间序列，ts1, ts2, 画在左轴；右轴画两者的差
% 有一定通用性，故不放在private中
% @luhuaibao
% 2014.6.3

n1 = length(ts1);
n2 = length(ts2);
if n1~=n2
    error('两序列长度不等！');
end ; 


 
x = (1:n1)';
y1 = ts1;
y2 = ts2 ;
y3 = y1-y2 ; 

setplot.plottype = [{'plot'},{'bar'}]; 
setplot.legend = [{'ts1'},{'ts2'},{'价差'} ]; 
setplot.title = '序列走势及差值'; 
 

plotdata.x = x ; 
plotdata.y1 =  [y1,y2]  ; 
plotdata.y2 = y3 ; 
iplot.plotYY(plotdata, setplot);
 

x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 


x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 
prct = prctile(y3,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 

 


end

