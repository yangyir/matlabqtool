%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������������Ӧ�����ؼ���������Ӧ����ֵ���ݸ�h�ؼ���string��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calendar_callback(h)

uicalendar('Weekend', [1 0 0 0 0 0 1],'SelectionType', 1,'OutputDateFormat','yyyy-mm-dd','DestinationUI',{h,'string'});

end