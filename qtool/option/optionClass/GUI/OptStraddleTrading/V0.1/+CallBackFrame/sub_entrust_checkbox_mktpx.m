function sub_entrust_checkbox_mktpx(hObject, eventdata, handles)
% 期权交易市场价的选择
% 吴云峰 20170329

set(hObject, 'Value', true)
set(handles.sub_entrust.table_limitprice, 'Data', cell(0, 2))
set(handles.sub_entrust.checkbox_limitprice, 'Value', false)



end