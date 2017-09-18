%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于Main中右图2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_right2_m(f,main)

h = axes('parent',f,'position',[0.84,0.35,0.15,0.21]);

hold on;

bar(1,main.win_averet,0.5,'r');
bar(2,main.lose_averet,0.5,'g');

hold off;
% 数值
if main.win_averet ~= 0
    text(0.8,main.win_averet/2,num2str(100*main.win_averet));
end
if main.lose_averet ~= 0
    text(1.8,main.lose_averet/2,num2str(100*main.lose_averet));
end

set(gca,'xticklabel','');
set(gca,'xtick',0:1:2,'xticklabel',{' ','盈利','损失'});

title('平均盈利与损失 (%)');

axis off;


end
