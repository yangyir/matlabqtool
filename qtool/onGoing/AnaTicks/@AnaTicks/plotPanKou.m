function [ ] = plotPanKou( ts, cur, pre_win, post_win )
%PLOTPANKOU 画指定点附近的盘口挂单情况
% chenggang; 140609; 对IF和stock测试通过

%% 预处理
if ~isa(ts, 'Ticks')
    disp('错误：数据类型必须是Ticks');
    return;
end

if ~exist('pre_win', 'var'),    pre_win = 2; end
if ~exist('post_win', 'var'),   post_win = 1; end

    
len = length(ts.time) ; 

vo = ts.volume; % 股、手
dvo = [vo(1); diff(vo) ];



% 算出tickValue, 未必不会错， 如果只有1档就肯定错了
dp = abs( diff(ts.last) );
tickValue = min( dp(dp > 1e-6) ) ;

%% subplot 盘口多图
tmp_st = max(1, cur - pre_win);
tmp_et = min(len, cur + post_win);
ylim = [min(min(ts.bidP(tmp_st:tmp_et,:)))-tickValue, max(max(ts.askP(tmp_st:tmp_et,:)))+tickValue];
xmax = max(max([ts.askV(tmp_st:tmp_et,:),ts.bidV(tmp_st:tmp_et,:)]));
xmax =  max( max(dvo(tmp_st:tmp_et)), xmax);
% xlim = [0, ceil(xmax/100)*100];
xlim = [ 0, xmax];



N = tmp_et - tmp_st + 1;
subplot_i = 1;
for tk = tmp_st:tmp_et
    subplot(1,N,subplot_i); hold off;
    subplot_i = subplot_i + 1;
    barh(ts.askP(tk,:), ts.askV(tk,:),'b');
    hold on;
    barh(ts.bidP(tk,:), ts.bidV(tk,:),'g');
    barh(ts.last(tk), dvo(tk),0.5*tickValue, 'y');
    title(sprintf('tick%d',tk) );
    if tk == cur
        title(sprintf('tick%d*',tk));
    end
    set(gca, 'YLim', ylim, 'XLim', xlim);
    
    % 如有闲时，设立一下标尺标记 ylim(1):tickValue:ylim(2)
    
end

end

