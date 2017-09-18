function main_button_accproportion(hObject, eventdata, handles)
% �˻�������˻����ƻص�����
% wuyunfeng 20170329

global MULTI_INSTANCE;

% ��ȡ��ǰ���˻������ַ���
proportion_str_ = get(handles.edit_pre_account_proportion, 'String');
proportion_str_ = regexp(proportion_str_, '/', 'split');
proportion_     = str2double(proportion_str_);
len_keys_account_ = length(keys(MULTI_INSTANCE));
nan_flag = any(isnan(proportion_));
len_flag = length(proportion_) == len_keys_account_;
if nan_flag
    warndlg('�˻�������������')
    return;
end
if len_flag
    MULTI_INSTANCE.proportion = proportion_;
    % �ַ���������
    proportion_after_str_ = '';
    for t = 1:len_keys_account_
        proportion_after_str_ = [proportion_after_str_, num2str(proportion_(t)), ':'];
    end
    set(handles.edit_after_account_proportion, 'String', proportion_after_str_(1:end-1))
else
    warndlg('�˻�������������')
    return;
end









end