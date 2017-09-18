%% *************************** 研究挂单深度 ************************* 
% luhuaibao
% 2014.6.3




%% 

n = length(ticks.time) ; 
ts = ticks ; 

%% 
% function [ output_args ] = f_plot2( ts, cur, twindow )
%F_PLOT2 实时动画，价格图和盘口图，
% 左图：线图，回溯twindow格
% 右图：盘口图，当前时点
% cur是当前时点



len = ts.latest;
twindow = 30 ;
for cur = twindow:len
    
if ~exist('cur','var'), cur = len; end
if ~exist('twindow', 'var'), twindow = 30; end

vo = ts.volume;
dvo = [vo(1); diff(vo)];

last = ts.last(1:cur);
ask = ts.askP(1:cur,1);
bid = ts.bidP(1:cur,1);
ordbk = nan(cur,2);
ordbk(:,1) =  ts.askV(1:cur,1)./sum( ts.askV(1:cur,:),2)*100;
ordbk(:,2) = ts.bidV(1:cur,1)./sum( ts.bidV(1:cur,:),2)*100;

sigma = std(last)*sqrt(cur/len);


%%
st = max(1, cur - twindow);
et = min(len, cur);

%% 价格单图
%             画图

figure(101); hold off;
subplot(1, 2, 1); hold off;

% [ax,h1,h2]=plotyy(st:et, [ask(st:et), bid(st:et)], st:et, [ordbk(:,1),ordbk(:,2)] ,@plot,@plot);
[ax,h1,h2]=plotyy(st:et,  ordbk(st:et,1)-ordbk(st:et,2) , st:et, last(st:et) ,@plot,@plot);

set(h2,'LineStyle','--' );
set(ax(1),'fontsize',7);
set(ax(2),'fontsize',7);
% YMX = max(ask_bid_spread(st:et)); set(ax(2),'ylim',[0.6, YMX*2]);

% title(sprintf('sigma%0.1f,' , sigma));
% legend( 'ask','bid','abspread','fontsize',3);
% legend('boxoff');
 

 
 %% subplot 盘口单图        

%  ylim = get(ax(1), 'ylim');
 
ymax = max(max(ts.askP( et,:)));
ymin = min(min(ts.askP( et,:)));

%  xmax =  max( max(dvo(st:et)), xmax);
 xlim = [0, 100];
 ylim = [ymin-1 ,ymax+1 ];
 
 
 tk = cur;
 figure(101); hold off;
 subplot(1, 2, 2); hold off;
 
 barh(ts.askP(tk,:), ts.askV(tk,:),0.15, 'g');
 hold on;
 barh(ts.bidP(tk,:), ts.bidV(tk,:),0.15, 'r');
%  barh(ts.last(tk), dvo(tk),0.1, 'y');
 %          legend('ask', 'bid', 'volume');
 
 title(sprintf('tick%d',tk) );
 set(gca, 'YLim', ylim, 'XLim', xlim,'fontsize',7);
 
 
 %%
 ts.askV(et,:)
 ts.bidV(et,:)
 pause() ; 
 
end ; 