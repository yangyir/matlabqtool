%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于生成相应日历控件，并将相应日期值传递给h控件‘string’
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calendar_callback(h)

uicalendar('Weekend', [1 0 0 0 0 0 1],'SelectionType', 1,'OutputDateFormat','yyyy-mm-dd','DestinationUI',{h,'string'});

end