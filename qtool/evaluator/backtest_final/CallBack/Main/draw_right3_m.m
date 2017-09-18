%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������Main����ͼ3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_right3_m(f,main)

h = axes('parent',f,'position',[0.84,0.08,0.15,0.21]);

hold on;

if main.accumreturn > 0
    bar(1,main.accumreturn,0.5,'r');
else
    bar(1,main.accumreturn,0.5,'g');
end
 text(0.8,main.accumreturn/2,num2str(100*main.accumreturn));
 
% ����ҵ����׼
if ~isfield(main,'benchmark')
    title('���������� (%)');
    bar(2,0,0.5);
else
    if main.benchmark > 0
        bar(2,main.benchmark,0.5,'r');
    else
        bar(2,main.benchmark,0.5,'g');
    end
    text(1.8,main.benchmark/2,num2str(100*main.benchmark));
    title('����������vs��׼������ (%)');
end
 
hold off;

set(gca,'xticklabel','');
axis off;

end