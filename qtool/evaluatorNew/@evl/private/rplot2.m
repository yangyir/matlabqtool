function [] = rplot2(Date1, nav1, Date2, nav2)
% �������л���ֵ����ֵ��ʽ��ʱ�䣬������ֵ�Ա�ͼ 
% ----------------------------------------------
% ��һ�� 08/01/2015
h = plot(Date1, nav1, Date2, nav2);
grid on
set(h(1),'color','r','linewidth',2);
set(h(2),'color','b','linewidth',2);

set(gca,'XTick',29)
datetick('x',29);

set(gca,'xlim',[min(Date1(1),Date2(1)),max(Date1(end),Date2(end))]);

title('��ֵ-���� ����');
xlabel('ʱ��');
ylabel(gca,'����')
legend('��Ʊ1','��Ʊ2','location','northwest')  
end
