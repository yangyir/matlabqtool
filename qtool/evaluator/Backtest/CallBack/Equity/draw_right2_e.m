%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڻ�Equity��ͼ2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_right2_e(f,equity)
h = axes('parent',f,'position',[0.84,0.35,0.15,0.21]);

hold on;
bar(1,equity.maxConwl(1),0.5,'r');
bar(2,equity.maxConwl(2),0.5,'g');
% ��ֵ�ı�
if equity.maxConwl(1) ~= 0
    text(1,equity.maxConwl(1)/2,num2str(equity.maxConwl(1)));
end
if equity.maxConwl(2) ~= 0
    text(2,equity.maxConwl(2)/2,num2str(equity.maxConwl(2)));
end

hold off;

set(gca,'xticklabel','');
set(gca,'xtick',0:1:2,'xticklabel',{' ','ӯ��','��ʧ'});
title('�������ӯ������ʧ����');

axis off;

end