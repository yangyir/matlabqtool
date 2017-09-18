function handles = optstraddletrading_entry(qms_, multi_)
% ��ȨStraddle���׽���ؼ��Ļ���
%handles = UIFrame.optstraddletrading_entry(qms_, multi)
% ���Ʒ� 20170328

% ȫ�ֱ���
global QMS_INSTANCE;
global MULTI_INSTANCE;
global STRA_INSTANCE;
global OPTSTRUCTURE_INSTANCE;
STRA_INSTANCE  = [];
QMS_INSTANCE   = qms_;
MULTI_INSTANCE = multi_;
OPTSTRUCTURE_INSTANCE = OptStructureConfig;



% ������
handles = UIFrame.mainframe;
% ���˻�����-ί���µ�
handles.sub_entrust = UIFrame.subframe_entrust(handles.panel_entrust, handles.output);
% ���˻�����-���������ͼ
handles.sub_payoff  = UIFrame.subframe_payoff(handles.panel_payoff);
movegui(handles.output, 'center')
 

% 1,��������
table_optcode = handles.sub_entrust.table_optcode;
[nT, nK] = size(qms_.callQuotes_.data);
table_optcode_colnames_ = repmat({'Call','Put','��','��','��/ƽ','��/ƽ'}, 1, nT);
table_optcode_rownames_ = num2cell(qms_.callQuotes_.xProps)';
table_optcode_rownames_ = cellfun(@(x)sprintf('%.3f',x), table_optcode_rownames_, 'UniformOutput', false);
table_optcode_data_ = cell(nK, 6 * nT);
table_optcode_editable_ = repmat([false, false, true(1, 4)], 1, nT);
table_optcode_colwidth_ = repmat({66,66,44,44,47,47}, 1, nT);
table_optcode_format_   = repmat({'char','char','char','char',{'��','ƽ'},{'��','ƽ'}}, 1, nT);
for t = 1:nT
    table_optcode_colnames_{6*t-5} = [datestr(qms_.callQuotes_.yProps{t}, 'mmdd'),'(C)'];
    table_optcode_colnames_{6*t-4} = [datestr(qms_.callQuotes_.yProps{t}, 'mmdd'),'(P)'];
    for k = 1:nK
        if qms_.callQuotes_.data(t, k).is_obj_valid
            callcode_ = qms_.callQuotes_.data(t, k).code;
            putcode_  = qms_.putQuotes_.data(t, k).code;
            % code
            table_optcode_data_{k, 6*t-5} = [ '<html><font color=#9400D3>', callcode_, '</font></html>' ];
            table_optcode_data_{k, 6*t-4} = [ '<html><font color=#DC143C>', putcode_ , '</font></html>' ];
        else
            table_optcode_data_{k, 6*t-5} = [ '<html><font color=#9400D3>', '********', '</font></html>' ];
            table_optcode_data_{k, 6*t-4} = [ '<html><font color=#DC143C>', '********', '</font></html>' ];
        end
        table_optcode_data_{k, 6*t-3} = '';
        table_optcode_data_{k, 6*t-2} = '';
        table_optcode_data_{k, 6*t-1} = '��';
        table_optcode_data_{k, 6*t-0} = '��';
    end
end
set(table_optcode, 'Data', table_optcode_data_, 'ColumnFormat', table_optcode_format_, ...
    'ColumnEditable', table_optcode_editable_, 'ColumnWidth', table_optcode_colwidth_, ...
    'ColumnName', table_optcode_colnames_, 'RowName', table_optcode_rownames_)


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
set(handles.popup_account_select, 'String', popup_account_str_)
set(handles.edit_account_name, 'String', account_show_buffer_)
set(handles.edit_pre_account_proportion, 'String', proportion_pre_str_(1:end-1))
set(handles.edit_after_account_proportion, 'String', proportion_after_str_(1:end-1))

% payoff���������
OPTSTRUCTURE_INSTANCE.m2tkCallQuote = QMS_INSTANCE.callQuotes_;
OPTSTRUCTURE_INSTANCE.m2tkPutQuote  = QMS_INSTANCE.putQuotes_;
OPTSTRUCTURE_INSTANCE.axes_handle   = handles.sub_payoff.axes_payoff;



% �ص�����������
% ��ǰ�˻�ѡ��
set(handles.popup_account_select, 'CallBack', {@CallBackFrame.main_popup_accselect, handles} ) 
% �˻�֮���������
set(handles.button_account_proportion, 'CallBack', {@CallBackFrame.main_button_accproportion, handles} ) 
% ��ǰ��Ȩ���������
set(handles.sub_entrust.table_optcode, 'CellSelectionCallback', {@CallBackFrame.sub_entrust_table_optcellselect, handles})
% �鿴��Ȩ������
set(handles.sub_entrust.menu_optquote, 'CallBack', {@CallBackFrame.sub_entrust_menu_optquote, handles})
% �мۺ��޼۵�����
set(handles.sub_entrust.checkbox_mktprice  , 'CallBack', {@CallBackFrame.sub_entrust_checkbox_mktpx  , handles})
set(handles.sub_entrust.checkbox_limitprice, 'CallBack', {@CallBackFrame.sub_entrust_checkbox_limitpx, handles})
% �����µ�
set(handles.sub_entrust.button_openfire, 'CallBack', {@CallBackFrame.sub_entrust_button_openfire, handles})
% һ������/һ����ѯ
set(handles.sub_entrust.button_querytotally , 'CallBack', {@CallBackFrame.sub_entrust_button_querytotally , handles})
set(handles.sub_entrust.button_canceltotally, 'CallBack', {@CallBackFrame.sub_entrust_button_canceltotally, handles})
% ����Book
set(handles.sub_entrust.button_savebooks, 'CallBack', {@CallBackFrame.sub_entrust_button_savebooks, handles})
% �������
set(handles.sub_entrust.button_clearoptcode, 'CallBack', {@CallBackFrame.sub_entrust_button_clearoptcode, handles})
% �ض�����
set(handles.sub_entrust.menu_optcancel, 'CallBack', {@CallBackFrame.sub_entrust_menu_optcancel, handles})

% ��ͼ�ص�����
set(handles.extras, 'Callback', {@CallBackFrame.extras_change_window, handles})
set(handles.sub_entrust.button_payoffplot, 'CallBack', {@CallBackFrame.sub_entrust_button_payoffplot, handles})










end