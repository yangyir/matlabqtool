function [] = rPlot(nav1,Date1)
% ������ֵ����ֵ��ʽ��ʱ�䣬������ֵ-��������
% -------------------------------
% ��һ�� 08/01/2015
yield1 = nav1(2:end)./nav1(1:end-1)-1;
[ax,h1,h2] = plotyy(Date1(2:end),yield1,Date1, nav1,'bar','plot');
grid on
set(h2,'color','r','linewidth',3);

set(h1,'BarWidth',0.5);

%%

set(ax(2),'XTick',0);
set(ax(1),'XTick',0)
datetick('x',29);
set(ax(1),'xlim',[Date1(1),Date1(end)]);
set(ax(2),'xlim',[Date1(1),Date1(end)]);


title('��ֵ-���� ����');
xlabel('ʱ��');
ylabel(ax(1),'����')
ylabel(ax(2),'��ֵ')
legend('����','��ֵ','location','northwest')
end
