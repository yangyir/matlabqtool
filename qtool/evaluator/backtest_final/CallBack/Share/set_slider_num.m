%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������ڽ�handle(1)��Ӧ��slider��value�������������
% ���ݸ�handle(2)��Ӧedit��string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_slider_num(handle)

Num=get(handle(1),'value'); 
set(handle(2),'string', num2str(floor(Num)));
end