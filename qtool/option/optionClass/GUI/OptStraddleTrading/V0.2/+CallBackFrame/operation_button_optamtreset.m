function operation_button_optamtreset(hObject, eventdata, handles)
% �����������������
% wuyunfeng 20170415

global OPT_INIT_AMOUNTS;

table_optopensel  = handles.asset.table_optopensel;
table_optclosesel = handles.asset.table_optclosesel;
set(table_optopensel , 'Data', OPT_INIT_AMOUNTS)
set(table_optclosesel, 'Data', OPT_INIT_AMOUNTS)





end