%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڻ�Equity��ͼ1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_right1_e(f,equity)

h=axes('parent',f,'position',[0.84,0.63,0.15,0.21]);
hold on;

bar(1,equity.win_day,0.5,'r');
bar(2,equity.lose_day,0.5,'g');

set(gca,'xticklabel','');
set(gca,'xtick',0:1:2,'xticklabel',{' ','ӯ��','��ʧ'});
% ��ֵ�ı�
if equity.win_day ~= 0
    text(1,equity.win_day/2,num2str(equity.win_day));
end
if equity.lose_day ~= 0
    text(2,equity.lose_day /2,num2str(equity.lose_day ));
end

title('ӯ������ʧ����');

hold off;
axis off;
end