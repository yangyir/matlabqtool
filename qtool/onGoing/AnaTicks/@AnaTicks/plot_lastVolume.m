function  plot_lastVolume( ticks )
%plot_lastVolume 画图，左轴last,右轴volume
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
y1 = ticks.last(1:n );
y2 = [ticks.volume(1); diff( ticks.volume(1:n ))] ;
 

setplot.plottype = [{'plot'},{'bar'}]; 
setplot.legend = [{'last'},{'volume'} ]; 
setplot.title = 'ticks: last-volume'; 
 

plotdata.x = x ; 
plotdata.y1 =  y1  ; 
plotdata.y2 = y2 ; 
iplot.plotYY(plotdata, setplot);
 

x = get(gca,'Xlim') ;  %x轴范围
y = get(gca,'Ylim') ;%y轴范围
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 


vol = nanstd(y1) ; 
volumeAvg = nanmean(y2);

text(x,y,sprintf( '日波动率/点: %0.3f \n单位ticks成交量: %0.3f ', vol, volumeAvg ),'fontsize',7) ; 




end

