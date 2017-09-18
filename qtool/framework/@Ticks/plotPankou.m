function [ ] = plotPankou( obj, cur, pre_win, post_win )
%PLOTPANKOU 画指定点附近的盘口挂单情况
% 原来放在AnaTicks类中，现在移入Ticks类中
% chenggang; 140609; 对IF和stock测试通过

%% 预处理

if ~exist('cur', 'var') 
    if isempty(obj.latest), obj.latest = 0; end
    if obj.latest >= 1 && obj.latest <= length(obj.time)
        cur = obj.latest; 
    else
        disp('请指定tick#，否则默认Ticks.latest,若仍有错，默认1');
        cur = 1;
    end
end
    
if ~exist('pre_win', 'var'),    pre_win = 0; end
if ~exist('post_win', 'var'),   post_win = 0; end

    
len = length(obj.time) ; 

vo  = obj.volume;
dvo = [vo(1); diff(vo) ];



% 算出tickValue, 未必不会错， 如果只有1档就肯定错了
dp = abs( diff(obj.last) );
tickValue = min( dp(dp > 1e-6) ) ;


%% subplot 盘口多图
tmp_st  = max(1, cur - pre_win);
tmp_et  = min(len, cur + post_win);
ylim    = [min(min(obj.bidP(tmp_st:tmp_et,:)))-2*tickValue, ...
            max(max(obj.askP(tmp_st:tmp_et,:)))+2*tickValue];
xmax    = max(max([obj.askV(tmp_st:tmp_et,:),obj.bidV(tmp_st:tmp_et,:)]));
xmax    =  max( max(dvo(tmp_st:tmp_et)), xmax);
xlim    = [ 0, xmax];



N = tmp_et - tmp_st + 1;
subplot_i = 1;
for tk = tmp_st:tmp_et
    subplot(1,N,subplot_i); hold off;
    subplot_i = subplot_i + 1;
    barh(obj.askP(tk,:), obj.askV(tk,:),0.8*tickValue, 'b');
    hold on;
    barh(obj.bidP(tk,:), obj.bidV(tk,:),0.8*tickValue, 'g');
    barh(obj.last(tk), dvo(tk),0.5*tickValue, 'y');
    title(sprintf('tick%d',tk) );
    if tk == cur
        title(sprintf('%s: tick%d*',obj.code, tk));
    end
    set(gca, 'YLim', ylim, 'XLim', xlim);
    
    % 如有闲时，设立一下标尺标记 ylim(1):tickValue:ylim(2)
    
end

end


