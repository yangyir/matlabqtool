function [  ] = animate_pankou(ticks, stk, etk, step, pauseSec)
%ANIMATE_PANKOU 动画展示盘口数据
% stk, etk, step:     起终tk和step
% pauseSec:           每帧暂停秒数
% 程刚; 140616


%% 预处理
if ~isa(ticks, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end


len = length(ticks.time) ; % = ticks.latest;
etk = min(len, etk);

if (stk >= etk )
    disp('错误：起始stk应 < 中止etk');
    return;
end


if ~exist('pauseSec', 'var'),   pauseSec = 0.5; end
if ~exist('step', 'var'),       step = 1; end


vo = ticks.volume;
dvo = [vo(1); diff(vo) ];



% 算出tickValue, 未必不会错
dp = abs( diff(ticks.last) );
tickValue = min( dp(dp > 1e-6) ) ;


%% subplot 盘口多图
ylim = [min(min(ticks.bidP(stk:etk,:)))-tickValue, max(max(ticks.askP(stk:etk,:)))+tickValue];
xmax = max(max([ticks.askV(stk:etk,:),ticks.bidV(stk:etk,:)]));
xmax =  max( max(dvo(stk:etk)), xmax);
xlim = [ 0, xmax];


for tk = stk:step:etk
%     subplot(1,N,subplot_i); hold off;
    
    figure(616); hold off
    
    barh(ticks.askP(tk,:), ticks.askV(tk,:),'b');
    hold on;
    barh(ticks.bidP(tk,:), ticks.bidV(tk,:),'g');
    barh(ticks.last(tk), dvo(tk),0.5*tickValue, 'y');
    title(sprintf('tick%d*',tk) );
    
    set(gca, 'YLim', ylim, 'XLim', xlim);
    
    pause(pauseSec);
    
    % 如有闲时，设立一下标尺标记 ylim(1):tickValue:ylim(2)
    
end

end

