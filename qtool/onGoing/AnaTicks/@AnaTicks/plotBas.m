function  plotBas( ticks )
%plotBas 画图，左轴bid,ask,右轴价差
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end


if isempty(ticks.latest)
    n = length(ticks.last);
else
    n = ticks.latest ; 
end ; 

x = (1:n)';
y1 = ticks.bidP(1:n,1);
y2 = ticks.askP(1:n,1);
y3 = y2-y1 ; 
 

setplot.plottype = [{'plot'},{'bar'}]; 
setplot.legend = [{'bid'},{'ask'},{'bas'}]; 
setplot.title = 'bid-ask及价差'; 
 

plotdata.x = x ; 
plotdata.y1 = [y1,y2] ; 
plotdata.y2 = y3 ; 
[~,h1,~] = iplot.plotYY(plotdata, setplot);
 
set(h1(1),'color', 'b' ); 
set(h1(2), 'color','r' ); 

x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 
prct = prctile(y3,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10分位= %0.2f \n 20分位= %0.2f \n 30分位= %0.2f \n 40分位= %0.2f \n 50分位= %0.2f \n 60分位= %0.2f \n 70分位= %0.2f \n 80分位= %0.2f \n 90分位= %0.2f ', prct),'fontsize',7) ; 

 
end

