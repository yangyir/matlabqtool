function [hfig] = plotSimple(nav, rfr, period, benchmark)
% ���������ڻ�����ֵ��״ͼ���������ߣ����Ҽ��㲿��ָ����ͼ����ʾ
% function [hfig] = plotSimple(nav, rfr, benchmark)
%   nav:����Ʊ��ֵ
%   rfr:  �޷������ʣ�Ĭ��5%  
%   period���������ڣ���ȡ����ֵ�� d365, d360, d245, w, m, q, y, Ĭ��Ϊd365
%   benchmark: ѡȡ��׼��ֵ��Ĭ����
%   hfig: ����ͼ�ľ��
% ȫ�����㶼ʹ��Ĭ��ֵ�������в�׼
%-------------------------------------
% tangyixin,20150512  
% �̸գ�20150520��benchmark��Ϊ��ѡ�����rfr
% �̸գ�20150525�����²�����ͼ������
% �̸գ�20150530���������period��ͼ�����ֵ���evl.rptSimpleʵ��

%% ǰ����
if ~exist('rfr', 'var')
    rfr = 0.05;
end

if ~exist('period', 'var')
    period = 'w';
end

GIVEN_BENCHMARK = 1;
if ~exist('benchmark', 'var')
    % �����漰benchmark�Ķ�������
    GIVEN_BENCHMARK = 0;
end


%% ���㾻ֵ������
y1 = nav;
L  = length(nav);
y2 = evl.nav2yield(nav);


% ����evl.rptSimple�����������
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


% ͼ��ע��
xlim = get(gca,'xlim');
ylim = get(gca, 'ylim');
x3 = xlim(2) - (xlim(2)-xlim(1)) * 6/10 ;
y3 = ylim(1) + (ylim(2)-ylim(1)) * 5/8;
x4 = xlim(2) - (xlim(2)-xlim(1)) * 9/10 ;
% y4 = ylim(1) + (ylim(2)-ylim(1)) * 5/8;
y4 = y3;


text(x3,y3,t1,'fontsize',8,'color','black');
text(x4,y4,t2,'fontsize',8,'color','black');

% ͼ�ı��������
legend('�����ۻ���ֵ','��λʱ������','location','northwest') ;
legend('boxoff');
title('���Ծ�ֵ����');

end

