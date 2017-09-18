function sub_entrust_button_querytotally(hObject, eventdata, handles)
% “ªº¸≤È—Ø
% Œ‚‘∆∑Â 20170329

global MULTI_INSTANCE;
global STRA_INSTANCE;

account_select = get(handles.popup_account_select, 'Value');
if account_select == 1
    MULTI_INSTANCE.query_all_pendingEntrusts;
else
    STRA_INSTANCE.query_book_pendingEntrusts;
end




end