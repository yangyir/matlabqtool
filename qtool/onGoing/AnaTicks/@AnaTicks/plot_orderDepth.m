function  plot_orderDepth( ticks ,cur, twindow  )
%plot_orderDepth      画ticks的盘口深度
% @luhuaibao
% 2014.6.7
% 2014.6.10， 修改为上下图，下图不固定

if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end


if isempty(ticks.latest)
    len = length(ticks.last);
else
    len = ticks.latest ;
end ;



if ~exist('cur','var'), cur = len; end
if ~exist('twindow', 'var'), twindow = 30; end



last = ticks.last(1:cur);
ask = ticks.askP(1:cur,1);
bid = ticks.bidP(1:cur,1);
ordbk = nan(cur,2);
ordbk(:,1) =  ticks.askV(1:cur,1)./sum( ticks.askV(1:cur,:),2)*100;
ordbk(:,2) = ticks.bidV(1:cur,1)./sum( ticks.bidV(1:cur,:),2)*100;

sigma = std(last)*sqrt(cur/len);


%%
st = max(1, cur - twindow);
et = min(len, cur);

%% 价格单图
%             画图


subplot(2, 1, 1)

x = st:et ;
y1 = ticks.bidP(x,1);
y2 = ticks.askP(x,1);
y3 = ticks.last(x);
vo = ticks.volume;
dvo = [vo(1); diff(vo)];
y4 = dvo(x);

plotdata.x = x ;
plotdata.y1 = [y1,y2,y3] ;
plotdata.y2 = y4 ;

setplot.plottype = [{'plot'},{'bar'}];
setplot.legend = [{'bid'},{'ask'},{'last'},{'volume'}];
setplot.title = 'bid ask last volume';

iplot.plotYY(plotdata, setplot);


% % [ax,h1,h2]=plotyy(st:et, [ask(st:et), bid(st:et)], st:et, [ordbk(:,1),ordbk(:,2)] ,@plot,@plot);
% [ax,h1,h2]=plotyy(st:et,  ordbk(st:et,1)-ordbk(st:et,2) , st:et, last(st:et) ,@plot,@plot);
%
% set(h2,'LineStyle','--' );
% set(ax(1),'fonticksize',7);
% set(ax(2),'fonticksize',7);
% YMX = max(ask_bid_spread(st:et)); set(ax(2),'ylim',[0.6, YMX*2]);

% title(sprintf('sigma%0.1f,' , sigma));
% legend( 'ask','bid','abspread','fonticksize',3);
% legend('boxoff');



%% subplot 盘口单图

%  ylim = get(ax(1), 'ylim');

ymax = max(max(ticks.askP( st:et ,:)));
ymin = min(min(ticks.askP( st:et ,:)));

%  xmax =  max( max(dvo(st:et)), xmax);
% xlim = [0, 100];
ylim = [ymin-1 ,ymax+1 ];


tk = cur;
subplot(2, 1, 2)

barh(ticks.askP(tk,:), ticks.askV(tk,:),0.15, 'g');
hold on
barh(ticks.bidP(tk,:), ticks.bidV(tk,:),0.15, 'r');
hold off
% set(gca, 'YLim', ylim, 'XLim', xlim,'fontsize',7);
set(gca, 'fontsize',7);
title(sprintf('tick%d',tk) );




end

