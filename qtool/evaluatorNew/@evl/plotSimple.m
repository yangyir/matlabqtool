function [hfig] = plotSimple(nav, rfr, period, benchmark)
% 本函数用于画出净值柱状图和收益曲线，并且计算部分指标在图上显示
% function [hfig] = plotSimple(nav, rfr, benchmark)
%   nav:　股票净值
%   rfr:  无风险利率，默认5%  
%   period：数据周期，可取如下值： d365, d360, d245, w, m, q, y, 默认为d365
%   benchmark: 选取基准净值，默认无
%   hfig: 返回图的句柄
% 全部计算都使用默认值，可能有不准
%-------------------------------------
% tangyixin,20150512  
% 程刚，20150520，benchmark做为可选项，加入rfr
% 程刚，20150525，重新布置了图中文字
% 程刚，20150530，输入加入period；图中文字调用evl.rptSimple实现

%% 前处理
if ~exist('rfr', 'var')
    rfr = 0.05;
end

if ~exist('period', 'var')
    period = 'w';
end

GIVEN_BENCHMARK = 1;
if ~exist('benchmark', 'var')
    % 所有涉及benchmark的都不做了
    GIVEN_BENCHMARK = 0;
end


%% 计算净值和收益
y1 = nav;
L  = length(nav);
y2 = evl.nav2yield(nav);


% 调用evl.rptSimple函数输出文字
if GIVEN_BENCHMARK
    [t1,t2] = evl.rptSimple( nav, rfr, period, benchmark ); 
else
    [t1,t2] = evl.rptSimple( nav, rfr, period ); 
end


%% Plot
hfig = figure;
[ax,h1,h2] = plotyy(1:L, y1,1:L-1,y2,'plot','bar');
set(ax(1),'xlim',[0,L]);
set(ax(2),'xlim',[0,L]);
grid on

set(h1,'color','r','linewidth',2);
set(h2,'linewidth',0.1,'Facecolor','b');


% 图中注释
xlim = get(gca,'xlim');
ylim = get(gca, 'ylim');
x3 = xlim(2) - (xlim(2)-xlim(1)) * 6/10 ;
y3 = ylim(1) + (ylim(2)-ylim(1)) * 5/8;
x4 = xlim(2) - (xlim(2)-xlim(1)) * 9/10 ;
% y4 = ylim(1) + (ylim(2)-ylim(1)) * 5/8;
y4 = y3;


text(x3,y3,t1,'fontsize',8,'color','black');
text(x4,y4,t2,'fontsize',8,'color','black');

% 图的标题等杂项
legend('策略累积净值','单位时间收益','location','northwest') ;
legend('boxoff');
title('策略净值曲线');

end

