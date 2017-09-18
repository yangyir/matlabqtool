function operation_button_entrustalloppo(hObject, eventdata, handles)
% 全部对手开火下单
% wuyunfeng 20170415

global MULTI_INSTANCE;
global STRA_INSTANCE;
% stra_, open_opt_table_, close_opt_table_, opposite_level_, guadan_level_, entrust_type_
if isempty(STRA_INSTANCE)
    stra_ = MULTI_INSTANCE;
else
    stra_ = STRA_INSTANCE;
end
open_opt_table_  = get(handles.asset.table_optopensel  , 'Data');
close_opt_table_ = get(handles.asset.table_optclosesel , 'Data');
opposite_level_  = get(handles.operation.popup_oppositeprice, 'Value') - 1;
guadan_level_    = get(handles.operation.popup_guadanprice  , 'Value') - 1;
entrust_type_    = 1;

CallBackFrame.openfire_entrust(stra_, open_opt_table_, close_opt_table_, ...
    opposite_level_, guadan_level_, entrust_type_);








end