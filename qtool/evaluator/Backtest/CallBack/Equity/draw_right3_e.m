%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڻ�Equity��ͼ3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_right3_e(f,equity)

h=axes('parent',f,'position',[0.84,0.08,0.15,0.21]);
equity.drawdown = [0,equity.drawdown,0];

b=bar(equity.drawdown,0.5,'r');

% ��ֵ�ı�
if equity.drawdown(2) ~= 0
    text(1.8,equity.drawdown(2)/2,num2str(100*equity.drawdown(2)));
end

set(gca,'xticklabel','','xlim',[1,3]);
title('���س� (%)');
axis off;

end