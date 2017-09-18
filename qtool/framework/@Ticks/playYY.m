function [ ] = playYY( obj, y2, xwin, y1win, step, pausesec, t_start, t_end)
% 动态展示作图，逐点play。双轴：用last作为Y1，另给一个Y2，二者同时显示作图
% y2 : 放在右轴的图线。可以为空（默认，不推荐），此时变成只播放last
% xwin, y1win : 动画现实窗格的大小, 固定值。默认 1200 * 10
% step : 动画播放的步长，默认 2
% pausesec : 暂停时间，默认0.01s，实际画图时间大于0.01s（也就是最快的动画了）
% t_start, t_end : 时间起讫，用的是点的序号，默认 1:end
% Cheng,Gang; 140215

%% 默认值  
if ~exist('xwin','var')
    xwin = 1200;
end

if ~exist('y1win','var')
    y1win = 10;
end

% 设定for循环的step
if ~exist('step', 'var')
    step = 2;
end

% pausesec : 暂停时间，默认0.01s，实际画图时间大于0.01s（也就是最快的动画了）
if ~exist('pausesec','var')
    pausesec = 0.01;
end

if ~exist('t_start', 'var')
    t_start = 1;
end

if ~exist('t_end', 'var')
    t_end = length(obj.last);
end



%% 初始化
p   = obj.last;
len = length(p);



% 需要y2和p同样长？



%% 初始axis
y1min   = p(1) - y1win/2;
y1max   = p(1) + y1win/2;
y1tick  = ceil(y1win/10);
xmin    = 1;
xmax    = xmin + xwin;

% 如果没有y2，就变成了单独播放Ticks
if ~exist('y2', 'var' ) 
    y2 = nan(length(obj.last),1);
    Y2MAX   = 1;
    Y2TICK  = ceil(Y2MAX/10);
else
    Y2MAX   = max(y2);
    Y2TICK  = ceil(Y2MAX/10);
end

%% 展示:逐点play
figure(101); hold off;

% 初始作图参数
left = 1;

% 作图速度无法再快了, 里面的判断不影响速度， 0.05s一个for
for t = t_start:step:t_end
% tic
    [ax,h1,h2] = plotyy(left:t, p(left:t), left:t, y2(left:t) );
    hold on;
    % 普通状态下，逐点作图，left记录上一个循环点， 作为起点
    left = t;
    
    
    % 动态调整x坐标：
    if t - xmin > xwin*3/4        
        % 下一个循环重新作图，甩掉图外部分，提高效率,使时间线性
        hold off;
        left = xmin;
        [ax,h1,h2] = plotyy(left:t, p(left:t), left:t, y2(left:t) );
        hold on;
                
        % 调整ｘ坐标
        xmin = xmin + xwin/4;
        xmax = xmax + xwin/4;
    end        
    
    % 动态调整y坐标: 下调
    if p(t) < y1min
        y1min = y1min - y1win/4;
        y1max = y1max - y1win/4;
    end
    
    % 动态调整y坐标：上调
    if p(t) > y1max
        y1min = y1min + y1win/4;
        y1max = y1max + y1win/4;
    end
    
    set(ax(1),'xlim',[xmin, xmax]);
    set(ax(2),'xlim',[xmin, xmax]);
    set(ax(1),'ylim',[y1min,y1max],'ytick',[y1min:y1tick:y1max]);  %左轴的范围
    set(ax(2),'ylim',[0,Y2MAX],'ytick',[0:Y2TICK:Y2MAX]);      %右轴的范围 
            
    pause( pausesec );
    
% toc
end

end

