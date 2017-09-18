function [ ] = playYY( obj, y2, xwin, y1win, step, pausesec, t_start, t_end)
% ��̬չʾ��ͼ�����play��˫�᣺��last��ΪY1�����һ��Y2������ͬʱ��ʾ��ͼ
% y2 : ���������ͼ�ߡ�����Ϊ�գ�Ĭ�ϣ����Ƽ�������ʱ���ֻ����last
% xwin, y1win : ������ʵ����Ĵ�С, �̶�ֵ��Ĭ�� 1200 * 10
% step : �������ŵĲ�����Ĭ�� 2
% pausesec : ��ͣʱ�䣬Ĭ��0.01s��ʵ�ʻ�ͼʱ�����0.01s��Ҳ�������Ķ����ˣ�
% t_start, t_end : ʱ���������õ��ǵ����ţ�Ĭ�� 1:end
% Cheng,Gang; 140215

%% Ĭ��ֵ  
if ~exist('xwin','var')
    xwin = 1200;
end

if ~exist('y1win','var')
    y1win = 10;
end

% �趨forѭ����step
if ~exist('step', 'var')
    step = 2;
end

% pausesec : ��ͣʱ�䣬Ĭ��0.01s��ʵ�ʻ�ͼʱ�����0.01s��Ҳ�������Ķ����ˣ�
if ~exist('pausesec','var')
    pausesec = 0.01;
end

if ~exist('t_start', 'var')
    t_start = 1;
end

if ~exist('t_end', 'var')
    t_end = length(obj.last);
end



%% ��ʼ��
p   = obj.last;
len = length(p);



% ��Ҫy2��pͬ������



%% ��ʼaxis
y1min   = p(1) - y1win/2;
y1max   = p(1) + y1win/2;
y1tick  = ceil(y1win/10);
xmin    = 1;
xmax    = xmin + xwin;

% ���û��y2���ͱ���˵�������Ticks
if ~exist('y2', 'var' ) 
    y2 = nan(length(obj.last),1);
    Y2MAX   = 1;
    Y2TICK  = ceil(Y2MAX/10);
else
    Y2MAX   = max(y2);
    Y2TICK  = ceil(Y2MAX/10);
end

%% չʾ:���play
figure(101); hold off;

% ��ʼ��ͼ����
left = 1;

% ��ͼ�ٶ��޷��ٿ���, ������жϲ�Ӱ���ٶȣ� 0.05sһ��for
for t = t_start:step:t_end
% tic
    [ax,h1,h2] = plotyy(left:t, p(left:t), left:t, y2(left:t) );
    hold on;
    % ��ͨ״̬�£������ͼ��left��¼��һ��ѭ���㣬 ��Ϊ���
    left = t;
    
    
    % ��̬����x���꣺
    if t - xmin > xwin*3/4        
        % ��һ��ѭ��������ͼ��˦��ͼ�ⲿ�֣����Ч��,ʹʱ������
        hold off;
        left = xmin;
        [ax,h1,h2] = plotyy(left:t, p(left:t), left:t, y2(left:t) );
        hold on;
                
        % ����������
        xmin = xmin + xwin/4;
        xmax = xmax + xwin/4;
    end        
    
    % ��̬����y����: �µ�
    if p(t) < y1min
        y1min = y1min - y1win/4;
        y1max = y1max - y1win/4;
    end
    
    % ��̬����y���꣺�ϵ�
    if p(t) > y1max
        y1min = y1min + y1win/4;
        y1max = y1max + y1win/4;
    end
    
    set(ax(1),'xlim',[xmin, xmax]);
    set(ax(2),'xlim',[xmin, xmax]);
    set(ax(1),'ylim',[y1min,y1max],'ytick',[y1min:y1tick:y1max]);  %����ķ�Χ
    set(ax(2),'ylim',[0,Y2MAX],'ytick',[0:Y2TICK:Y2MAX]);      %����ķ�Χ 
            
    pause( pausesec );
    
% toc
end

end

