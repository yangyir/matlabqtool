
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于生成日历控件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tool_calendar_callback ()

uicalendar('Weekend', [1 0 0 0 0 0 1]','SelectionType', 1','OutputDateFormat','yyyy-mm-dd');


end