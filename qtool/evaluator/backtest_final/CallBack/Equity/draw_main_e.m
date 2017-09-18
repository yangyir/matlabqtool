%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于展现策略累计收益率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = draw_main_e(f,equity)

h = axes('parent',f,'position',[0.03,0.08,0.78,0.77]);

plot (equity.accum_returns(:,1),equity.accum_returns(:,2),'r',equity.IR_acc(:,1),equity.IR_acc(:,2),'g');
datetick(h,'x',29,'keepticks','keeplimits');

legend({'累计收益率','同期大盘累计收益率'});
title('收益率');

end
