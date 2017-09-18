function sub_entrust_button_openfire(hObject, eventdata, handles)
% 开火下单操作
% 吴云峰 20170329

global QMS_INSTANCE;
global MULTI_INSTANCE;
global STRA_INSTANCE;


% 查看到底是市价单还是限价单
mkt_select     = get(handles.sub_entrust.checkbox_mktprice,   'Value');
limit_select   = get(handles.sub_entrust.checkbox_limitprice, 'Value');
account_select = get(handles.popup_account_select, 'Value');


% 使用市场价
if mkt_select
    mktpx_level = get(handles.sub_entrust.popup_mktprice, 'Value') - 6;
    [nT, nK] = size(QMS_INSTANCE.callQuotes_.data);
    opt_entrustinfo_ = get(handles.sub_entrust.table_optcode, 'Data');
    for t = 1:nT
        for k = 1:nK
            
            % Call
            optQuote_ = QMS_INSTANCE.callQuotes_.data(t, k);
            if optQuote_.is_obj_valid
                entrust_amount = opt_entrustinfo_{k, 6*t-3};
                if isempty(entrust_amount)
                else
                    entrust_amount = str2double(entrust_amount);
                    if isnan(entrust_amount)
                    else
                        if entrust_amount > 0
                            entrust_direction = '1';
                        else
                            entrust_direction = '2';
                        end
                        future_direction = opt_entrustinfo_{k, 6*t-1};
                        if strcmp(future_direction, '开')
                            future_direction = '1';
                        else
                            future_direction = '2';
                        end
                    end
                    entrust_px  = get_mktlevel_price(optQuote_, mktpx_level, entrust_direction);
                    entrust_amt = abs(entrust_amount);
                    if entrust_px >= 0.0001-eps
                        if account_select == 1
                            MULTI_INSTANCE.set_opt(t, optQuote_.K, optQuote_.CP);
                            MULTI_INSTANCE.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                        else
                            STRA_INSTANCE.set_opt(t, optQuote_.K, optQuote_.CP);
                            STRA_INSTANCE.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                        end
                    end
                end
            end
            
            % Put
            optQuote_ = QMS_INSTANCE.putQuotes_.data(t, k);
            if optQuote_.is_obj_valid
                entrust_amount = opt_entrustinfo_{k, 6*t-2};
                if isempty(entrust_amount)
                else
                    entrust_amount = str2double(entrust_amount);
                    if isnan(entrust_amount)
                    else
                        if entrust_amount > 0
                            entrust_direction = '1';
                        else
                            entrust_direction = '2';
                        end
                        future_direction = opt_entrustinfo_{k, 6*t};
                        if strcmp(future_direction, '开')
                            future_direction = '1';
                        else
                            future_direction = '2';
                        end
                    end
                    entrust_px  = get_mktlevel_price(optQuote_, mktpx_level, entrust_direction);
                    entrust_amt = abs(entrust_amount);
                    if entrust_px >= 0.0001-eps
                        if account_select == 1
                            MULTI_INSTANCE.set_opt(t, optQuote_.K, optQuote_.CP);
                            MULTI_INSTANCE.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                        else
                            STRA_INSTANCE.set_opt(t, optQuote_.K, optQuote_.CP);
                            STRA_INSTANCE.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                        end
                    end
                end
            end
            
        end
    end
    

% 使用限价    
elseif limit_select
    limit_table_handle = handles.sub_entrust.table_limitprice;
    limit_info_data    = get(limit_table_handle, 'Data');
    line_ = size(limit_info_data, 1);
    if isempty(limit_info_data)
    else
        for t = 1:line_
            [~,cp,expire,strike,entrust_direction,future_direction,entrust_amt,entrust_px] = limit_info_data{t,:};
            entrust_px = str2double(entrust_px);
            if isnan(entrust_px)
            else
                if account_select == 1
                    MULTI_INSTANCE.set_opt(expire, strike, cp);
                    MULTI_INSTANCE.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                else
                    STRA_INSTANCE.set_opt(expire, strike, cp);
                    STRA_INSTANCE.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                end
            end
        end
    end
end

% 将限价的列表进行清除
if limit_select
    set(handles.sub_entrust.table_limitprice, 'Data', cell(0));
end








end

function px = get_mktlevel_price(optQuote_, mktlevel, entrust_direction)

% 买
if entrust_direction == '1'
    switch mktlevel
        case -5
            px = optQuote_.askP5;
        case -4
            px = optQuote_.askP4;
        case -3
            px = optQuote_.askP3;
        case -2
            px = optQuote_.askP2;
        case -1
            px = optQuote_.askP1;
        case 0
            px = optQuote_.last;
        case 1
            px = optQuote_.bidP1;
        case 2
            px = optQuote_.bidP2;
        case 3
            px = optQuote_.bidP3;
        case 4
            px = optQuote_.bidP4;
        case 5
            px = optQuote_.bidP5;
    end       
% 卖    
else
    switch mktlevel
        case -5
            px = optQuote_.bidP5;
        case -4
            px = optQuote_.bidP4;
        case -3
            px = optQuote_.bidP3;
        case -2
            px = optQuote_.bidP2;
        case -1
            px = optQuote_.bidP1;
        case 0
            px = optQuote_.last;
        case 1
            px = optQuote_.askP1;
        case 2
            px = optQuote_.askP2;
        case 3
            px = optQuote_.askP3;
        case 4
            px = optQuote_.askP4;
        case 5
            px = optQuote_.askP5;
    end
end








end