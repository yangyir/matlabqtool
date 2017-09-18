function  [ax,h1,h2] = plotYY( data,setplot )
%   PLOTYY 画双坐标
%   demo:
% x = 1:nt ;
% y1 = bars.close ;
% y2 = [ nan ; diff(y1) ] ;
% setplot.plottype = [{'plot'},{'bar'}]; 
% setplot.legend = [{'data1'},{'data2'}]; 
% setplot.title = '权益曲线'; 
% 
% plotdata.x = x ; 
% plotdata.y1 = y1 ; 
% plotdata.y2 = y2 ; 
% 
% plotYY(plotdata, setplot);


%  version 1.0, luhuaibao, 2013.12.20 

x = data.x ; 
y1 = data.y1 ; 
y2 = data.y2 ; 

miny1 = floor(min(y1(:,1))-1)  ;
maxy1 = ceil(max(y1(:,1))+1) ;
stepy1 = round( (maxy1 - miny1)/5 ); 

miny2 = floor(min(y2(:,1))*(1-0.1))  ;
maxy2 = ceil(max(y2(:,1))*(1+0.1) )  ;
stepy2 = round( (maxy2 - miny2)/5 ); 
 
eval( ['[ax,h1,h2]=plotyy(x,y1,x,y2,@',setplot.plottype{1},',@',setplot.plottype{2},');']) ;
set(ax(1),'fontsize',7) ; 
set(ax(2),'fontsize',7) ; 
if strcmp(setplot.plottype{2},'bar')
    set(h2,'facecolor','y','edgecolor','y');
end ;
set(ax(1),'ylim',[miny1 maxy1],'ytick',miny1:stepy1:maxy1,'box','off');
set(ax(2),'ylim',[miny2 maxy2],'ytick',miny2:stepy2:maxy2,'box','off');

s1 = [] ; 
if ~isempty(setplot.legend)
    for i  = 1:length(setplot.legend)
        s1 = [s1,'setplot.legend{',num2str(i),'},'];
    end ;
end ; 
eval(['legend(',s1,'''location''',',','''Northwest''',' );'])
 

legend('boxoff');
title(setplot.title );


end

