function [  ] = animate_line_pankou( ticks, stk, etk, step, twindow, pauseSec)
%ANIMATE_LINE_PANKOU 动画展示盘口数据（右图）和价格线数据（左图）
% 左图：线图，回溯twindow格
% 右图：盘口图，当前时点
% stk, etk, step:     起终tk和step
% pauseSec:           每帧暂停秒数
% 程刚; 140617；写的不好，还要改


%% 预处理
if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end

len = ticks.latest;
etk = min(len, etk);

if (stk >= etk )
    disp('错误：起始stk应 < 中止etk');
    return;
end


if ~exist('step', 'var'), step = 1; end
if ~exist('twindow', 'var'), twindow = step*500; end
if ~exist('pauseSec', 'var'), pauseSec = 0.2; end

vo = ticks.volume;
dvo = [vo(1); diff(vo)];

last = ticks.last(:);
ask = ticks.askP(:,1);
bid = ticks.bidP(:,1);
ask_bid_spread = ask - bid;


% 算出tickValue, 未必不会错
dp = abs( diff(ticks.last) );
tickValue = min( dp(dp > 1e-6) ) ;


%% main

% 纵轴，全程用
ylim = [min(min(ticks.bidP(max(1,stk-twindow):etk,:)))-tickValue, max(max(ticks.askP(max(1,stk-twindow):etk,:)))+tickValue];

for cur = stk:step:etk

%%
st = max(1, cur - twindow);
et = min(len, cur);


sigma = std(last(st:et)) * sqrt( len/(et-st) );

%% 价格单图

figure(617); hold off;
subplot(1, 2, 1); hold off;

[ax,h1,h2]=plotyy(st:et, [ask(st:et), bid(st:et)], st:et, ask_bid_spread(st:et),@plot,@bar);
set(h2,'facecolor','y','edgecolor','y');

YMX = max(ask_bid_spread(st:et)); 
set(ax(2),'ylim',[0.6, YMX*2]);
set(ax(1), 'YLim', ylim);

title(sprintf('sigma%0.1f,' , sigma));
% legen( 'ask','bid','abspread');



 %% subplot 盘口单图        

%  ylim = get(ax(1), 'ylim');
 
% 算横轴
xmax = max(max([ticks.askV(st:et,:),ticks.bidV(st:et,:)]));
 xmax = max( max(dvo(st:et)), xmax);
 xlim = [0, xmax];
 
 tk = et;
 figure(617); hold off; 
 subplot(1, 2, 2); hold off;
 
 barh(ticks.askP(tk,:), ticks.askV(tk,:), 'b');
 hold on;
 barh(ticks.bidP(tk,:), ticks.bidV(tk,:), 'g');
 barh(ticks.last(tk), dvo(tk),0.5*tickValue, 'y');
 
 title(sprintf('tick%d*',tk) );
 set(gca, 'YLim', ylim, 'XLim', xlim);



 
 %% 暂停
 pause(pauseSec);
end


end

