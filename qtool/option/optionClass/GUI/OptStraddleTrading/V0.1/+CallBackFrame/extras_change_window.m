function extras_change_window(hObject, eventdata, handles)
% ��Ȩ����ҳ���ѡ��
% ���Ʒ� 20170329

global OPTSTRUCTURE_INSTANCE;
if eventdata.SelectedChild == 2
    if isempty(OPTSTRUCTURE_INSTANCE.s)
    else
        set(handles.output, 'WindowButtonDownFcn',...
            {@OptStructureConfig.payoff_pointer_callback, OPTSTRUCTURE_INSTANCE})
    end
else
    set(handles.output, 'WindowButtonDownFcn', '')
end






end