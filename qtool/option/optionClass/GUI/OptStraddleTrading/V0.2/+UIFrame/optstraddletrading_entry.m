function handles = optstraddletrading_entry(qms_, multi_)
% ��ȨStraddle���׽���ؼ��Ļ���
%handles = UIFrame.optstraddletrading_entry(qms_, multi)
% ���Ʒ� 20170415


% ȫ�ֱ���
global QMS_INSTANCE;
global MULTI_INSTANCE;
global STRA_INSTANCE;
global OPT_INIT_AMOUNTS;
global OPTSTRUCTURE_INSTANCE;
STRA_INSTANCE  = [];
QMS_INSTANCE   = qms_;
MULTI_INSTANCE = multi_;
OPTSTRUCTURE_INSTANCE = OptStructureConfig;


% ������
handles = UIFrame.mainframe;


% ��Ȩ�������������
table_optopensel  = handles.asset.table_optopensel;
table_optclosesel = handles.asset.table_optclosesel;
[nT, nK] = size(qms_.callQuotes_.data);
OPT_INIT_AMOUNTS = cell(2*nT, nK);
for t = 1:nT
    for k = 1:nK
        if qms_.callQuotes_.data(t, k).is_obj_valid
            % code
            OPT_INIT_AMOUNTS{2*t-1, k} = '';
            OPT_INIT_AMOUNTS{2*t, k}   = '';
        else
            OPT_INIT_AMOUNTS{2*t-1, k} = '****';
            OPT_INIT_AMOUNTS{2*t, k}   = '****';
        end
    end
end
set(table_optopensel,  'Data', OPT_INIT_AMOUNTS, 'ColumnEditable', true(1, nK))
set(table_optclosesel, 'Data', OPT_INIT_AMOUNTS, 'ColumnEditable', true(1, nK))
table_optcode_colnames_ = num2cell(qms_.callQuotes_.xProps);
table_optcode_colnames_ = cellfun(@(x)sprintf('%.3f',x), table_optcode_colnames_, 'UniformOutput', false);
date_str_ = datestr(qms_.callQuotes_.yProps, 'yymm');
call_rownames_ = [date_str_, repmat('C', length(date_str_), 1)];
put_rownames_  = [date_str_, repmat('P', length(date_str_), 1)];
table_optcode_rownames_ = [cellstr(call_rownames_), cellstr(put_rownames_)];
table_optcode_rownames_ = table_optcode_rownames_';
table_optcode_rownames_ = table_optcode_rownames_(:);
set(table_optopensel,  'ColumnName', table_optcode_colnames_, 'RowName', table_optcode_rownames_)
set(table_optclosesel, 'ColumnName', table_optcode_colnames_, 'RowName', table_optcode_rownames_)


% �˻���д��
keys_account_      = keys(MULTI_INSTANCE);
len_keys_account_  = length(keys_account_);
popup_account_str_ = cell(len_keys_account_+1, 1);
MULTI_INSTANCE.proportion = ones(1, len_keys_account_);
popup_account_str_{1} = '���';
account_show_buffer_  = '';
proportion_pre_str_   = repmat('1/', 1, len_keys_account_);
proportion_after_str_ = repmat('1:', 1, len_keys_account_);
for t = 1:len_keys_account_
    popup_account_str_{t+1} = keys_account_{t};
    account_show_buffer_ = sprintf('%s | %s', account_show_buffer_ , keys_account_{t});
end
account_show_buffer_ = [account_show_buffer_, ' |'];
set(handles.accountsel.popup_accountsel  , 'String', popup_account_str_)
set(handles.accountsel.edit_accountname  , 'String', account_show_buffer_)
set(handles.accountsel.edit_preproportion, 'String', proportion_pre_str_(1:end-1))
set(handles.accountsel.edit_aftproportion, 'String', proportion_after_str_(1:end-1))

% payoff���������
OPTSTRUCTURE_INSTANCE.m2tkCallQuote = QMS_INSTANCE.callQuotes_;
OPTSTRUCTURE_INSTANCE.m2tkPutQuote  = QMS_INSTANCE.putQuotes_;
OPTSTRUCTURE_INSTANCE.axes_handle   = handles.payofffig.axes_payoff;
set(handles.output, 'WindowButtonDownFcn',...
    {@OptStructureConfig.payoff_pointer_callback, OPTSTRUCTURE_INSTANCE})

% �ص�����������
%{ ��ǰ�˻�ѡ�� | �˻�֮��������� | ����Book���ձ��� %}
set(handles.accountsel.popup_accountsel,     'CallBack', {@CallBackFrame.accountsel_popup_accsel         , handles} ) 
set(handles.accountsel.button_setproportion, 'CallBack', {@CallBackFrame.accountsel_button_setproportion , handles} ) 
set(handles.accountsel.button_saveallbooks,  'CallBack', {@CallBackFrame.accountsel_button_saveallbooks  , handles})
%{ ������������ %}
set(handles.operation.button_optamtreset, 'CallBack', {@CallBackFrame.operation_button_optamtreset, handles})
%{ ȫ�� | ��԰�� | ȫ�Լ� %}
set(handles.operation.button_entrustallpend  , 'CallBack', {@CallBackFrame.operation_button_entrustallpend , handles})
set(handles.operation.button_entrusthalfpend , 'CallBack', {@CallBackFrame.operation_button_entrusthalfpend, handles})
set(handles.operation.button_entrustalloppo  , 'CallBack', {@CallBackFrame.operation_button_entrustalloppo , handles})
%{ һ������ | һ����ѯ %}
set(handles.operation.button_querytotally   , 'CallBack', {@CallBackFrame.operation_button_querytotally  , handles})
set(handles.operation.button_canceltotally  , 'CallBack', {@CallBackFrame.operation_button_canceltotally , handles})
% { payoff��ͼ %}
set(handles.operation.button_payoffinfo, 'CallBack', {@CallBackFrame.operation_button_payoffinfo, handles})
%{ ˲ʱ������ͼ %}
set(handles.operation.button_bdquote , 'CallBack', {@CallBackFrame.operation_button_bdquote , handles})
set(handles.operation.button_optquote, 'CallBack', {@CallBackFrame.operation_button_optquote, handles})









end