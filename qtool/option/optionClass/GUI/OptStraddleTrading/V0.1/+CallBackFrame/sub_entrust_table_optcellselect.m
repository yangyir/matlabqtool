function sub_entrust_table_optcellselect(hObject, eventdata, handles)
% 期权交易Table的期权价格类型的选择
% 吴云峰 20170329


global QMS_INSTANCE;


if isequal(size(eventdata.Indices), [1 2])
    select_kpos_ = eventdata.Indices(1);
    select_tpos_ = ceil(eventdata.Indices(2)/6);
    if mod(eventdata.Indices(2), 6) == 1
        optQuote_ = QMS_INSTANCE.callQuotes_.data(select_tpos_, select_kpos_);
    else
        optQuote_ = QMS_INSTANCE.putQuotes_.data(select_tpos_, select_kpos_);
    end
    set(handles.sub_entrust.contextmenu_opt, 'UserData', optQuote_)
    if optQuote_.is_obj_valid
        % 进行情的更新
        optQuote_.fillQuote;
        
        quote_data_ = get(handles.sub_entrust.table_quote, 'Data');
        % 卖价和卖量
        quote_data_{1,2} = num2str(optQuote_.askP5);
        quote_data_{1,3} = num2str(optQuote_.askQ5);
        quote_data_{2,2} = num2str(optQuote_.askP4);
        quote_data_{2,3} = num2str(optQuote_.askQ4);
        quote_data_{3,2} = num2str(optQuote_.askP3);
        quote_data_{3,3} = num2str(optQuote_.askQ3);
        quote_data_{4,2} = num2str(optQuote_.askP2);
        quote_data_{4,3} = num2str(optQuote_.askQ2);
        quote_data_{5,2} = num2str(optQuote_.askP1);
        quote_data_{5,3} = num2str(optQuote_.askQ1);
        % 最新价和最新成交量
        quote_data_{6,2} = num2str(optQuote_.last);
        quote_data_{6,3} = num2str(optQuote_.volume);
        % 买价和买量
        quote_data_{7,2}  = num2str(optQuote_.bidP1);
        quote_data_{7,3}  = num2str(optQuote_.bidQ1);
        quote_data_{8,2}  = num2str(optQuote_.bidP2);
        quote_data_{8,3}  = num2str(optQuote_.bidQ2);
        quote_data_{9,2}  = num2str(optQuote_.bidP3);
        quote_data_{9,3}  = num2str(optQuote_.bidQ3);
        quote_data_{10,2} = num2str(optQuote_.bidP4);
        quote_data_{10,3} = num2str(optQuote_.bidQ4);
        quote_data_{11,2} = num2str(optQuote_.bidP5);
        quote_data_{11,3} = num2str(optQuote_.bidQ5);
        set(handles.sub_entrust.table_quote, 'Data', quote_data_)
    end
end





end