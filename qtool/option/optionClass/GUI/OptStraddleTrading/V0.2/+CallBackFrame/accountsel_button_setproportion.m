function accountsel_button_setproportion(hObject, eventdata, handles)
% 账户管理的账户名称回调函数
% wuyunfeng 20170415

global MULTI_INSTANCE;

% 获取当前的账户比率字符串
edit_preproportion = handles.accountsel.edit_preproportion;
edit_aftproportion = handles.accountsel.edit_aftproportion;

proportion_str_ = get(edit_preproportion, 'String');
proportion_str_ = regexp(proportion_str_, '/', 'split');
proportion_     = str2double(proportion_str_);
len_keys_account_ = length(keys(MULTI_INSTANCE));
nan_flag = any(isnan(proportion_));
len_flag = length(proportion_) == len_keys_account_;
if nan_flag
    warndlg('账户比率设置有误')
    return;
end
if len_flag
    MULTI_INSTANCE.proportion = proportion_;
    % 字符串的设置
    proportion_after_str_ = '';
    for t = 1:len_keys_account_
        proportion_after_str_ = [proportion_after_str_, num2str(proportion_(t)), ':'];
    end
    set(edit_aftproportion, 'String', proportion_after_str_(1:end-1))
else
    warndlg('账户比率设置有误')
    return;
end








end