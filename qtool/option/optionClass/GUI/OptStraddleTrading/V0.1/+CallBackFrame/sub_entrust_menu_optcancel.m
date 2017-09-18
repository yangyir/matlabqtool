function sub_entrust_menu_optcancel(hObject, eventdata, handles)
% 基于特定的资产进行撤单
% 吴云峰 20170330


global MULTI_INSTANCE;
global STRA_INSTANCE;
account_select      = get(handles.popup_account_select, 'Value');
context_menu_handle = get(hObject, 'Parent');
optQuote_ = get(context_menu_handle, 'UserData');

if account_select == 1
    keys_ = keys(MULTI_INSTANCE);
    for k = 1:length(keys_)
        key_str_ = keys_{k};
        stra_    = get(MULTI_INSTANCE, key_str_);
        pending_lists = stra_.book.pendingEntrusts.node;
        for t = 1:length(pending_lists)
            instrumentCode = pending_lists(t).instrumentCode;
            if strcmp(instrumentCode, optQuote_.code)
                ems.cancel_optEntrust_and_fill_cancelNo(pending_lists(t), stra_.counter);
            end
        end
    end
else
    pending_lists = STRA_INSTANCE.book.pendingEntrusts.node;
    for t = 1:length(pending_lists)
        instrumentCode = pending_lists(t).instrumentCode;
        if strcmp(instrumentCode, optQuote_.code)
            ems.cancel_optEntrust_and_fill_cancelNo(pending_lists(t), STRA_INSTANCE.counter);
        end
    end
end










end