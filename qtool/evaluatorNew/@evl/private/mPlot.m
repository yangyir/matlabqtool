function [] = mPlot(nav1,Date1)
% ����nav��ת��Ϊ��ֵ��ʽ��ʱ�䣬��ͼ
% ---------------------
% ��һ�Σ�20150730
h = plot(Date1,nav1);
grid on
set(h,'color','b','linewidth',2);

datetick('x',29);
set(gca,'xlim',[Date1(1),Date1(end)]);
set(h,'markersize',4)
end
