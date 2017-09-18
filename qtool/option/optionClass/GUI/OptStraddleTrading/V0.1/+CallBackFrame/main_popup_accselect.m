function main_popup_accselect(hObject, eventdata, handles)
% 账户管理的账户选择回调函数
% wuyunfeng 20170329


global MULTI_INSTANCE;
global STRA_INSTANCE;
ids_select_ = get(hObject, 'Value');
if ids_select_ == 1
    STRA_INSTANCE = [];
    return;
end


keys_strs_    = get(hObject, 'String');
keys_str_     = keys_strs_{ids_select_};
STRA_INSTANCE = get(MULTI_INSTANCE, keys_str_);





end