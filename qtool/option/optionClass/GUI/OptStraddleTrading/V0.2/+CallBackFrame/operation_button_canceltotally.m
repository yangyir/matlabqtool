function operation_button_canceltotally(hObject, eventdata, handles)
% һ������
% ���Ʒ� 20170329

global MULTI_INSTANCE;
global STRA_INSTANCE;

if isempty(STRA_INSTANCE)
    MULTI_INSTANCE.cancel_all_pendingEntrusts;
else
    STRA_INSTANCE.book.cancel_pendingOptEntrusts(STRA_INSTANCE.counter);
end




end