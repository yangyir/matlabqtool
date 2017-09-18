function  plotBas( ticks )
%plotBas ��ͼ������bid,ask,����۲�
% @luhuaibao
% 2014.6.3

if ~isa(ticks, 'Ticks')
    disp('�����������ͱ�����Ticks');
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
setplot.title = 'bid-ask���۲�'; 
 

plotdata.x = x ; 
plotdata.y1 = [y1,y2] ; 
plotdata.y2 = y3 ; 
[~,h1,~] = iplot.plotYY(plotdata, setplot);
 
set(h1(1),'color', 'b' ); 
set(h1(2), 'color','r' ); 

x = get(gca,'Xlim') ;  %x�᷶Χ
y = get(gca,'Ylim') ;%y�᷶Χ
x = x(1)+(x(2) - x(1))/4*3 ; 
y = y(1)+(y(2) - y(1))/4*3 ; 
prct = prctile(y3,[10,20,30,40,50,60,70,80,90]);
text(x,y,sprintf( ' 10��λ= %0.2f \n 20��λ= %0.2f \n 30��λ= %0.2f \n 40��λ= %0.2f \n 50��λ= %0.2f \n 60��λ= %0.2f \n 70��λ= %0.2f \n 80��λ= %0.2f \n 90��λ= %0.2f ', prct),'fontsize',7) ; 

 
end

