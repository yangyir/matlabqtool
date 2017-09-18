%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于画Equity右图2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_right2_e(f,equity)
h = axes('parent',f,'position',[0.84,0.35,0.15,0.21]);

hold on;
bar(1,equity.maxConwl(1),0.5,'r');
bar(2,equity.maxConwl(2),0.5,'g');
% 数值文本
if equity.maxConwl(1) ~= 0
    text(1,equity.maxConwl(1)/2,num2str(equity.maxConwl(1)));
end
if equity.maxConwl(2) ~= 0
    text(2,equity.maxConwl(2)/2,num2str(equity.maxConwl(2)));
end

hold off;

set(gca,'xticklabel','');
set(gca,'xtick',0:1:2,'xticklabel',{' ','盈利','损失'});
title('最大连续盈利与损失天数');

axis off;

end