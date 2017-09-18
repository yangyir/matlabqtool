function sub_entrust_button_clearoptcode(hObject, eventdata, handles)
% 清理期权代码的数量
% 吴云峰 20170330

global QMS_INSTANCE;
nT = length(QMS_INSTANCE.callQuotes_.yProps);
nK = length(QMS_INSTANCE.callQuotes_.xProps);

optcode_handle_ = handles.sub_entrust.table_optcode;
config_data_    = get(optcode_handle_, 'Data');
for t = 1:nT
    for k = 1:nK
        config_data_{k, 6*t-3} = '';
        config_data_{k, 6*t-2} = '';
    end
end
set(optcode_handle_, 'Data', config_data_)





end