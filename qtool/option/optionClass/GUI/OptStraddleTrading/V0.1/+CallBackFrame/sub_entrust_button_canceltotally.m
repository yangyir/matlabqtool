function sub_entrust_button_canceltotally(hObject, eventdata, handles)
% Ò»¼ü³·µ¥
% ÎâÔÆ·å 20170329

global MULTI_INSTANCE;
global STRA_INSTANCE;

account_select = get(handles.popup_account_select, 'Value');
if account_select == 1
    MULTI_INSTANCE.cancel_all_pendingEntrusts;
else
    STRA_INSTANCE.book.cancel_pendingOptEntrusts(STRA_INSTANCE.counter);
end





end