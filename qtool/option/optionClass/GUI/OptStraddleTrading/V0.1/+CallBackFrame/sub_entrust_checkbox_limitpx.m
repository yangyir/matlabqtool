function sub_entrust_checkbox_limitpx(hObject, eventdata, handles)
% 期权交易Table的期权标的选择
% 吴云峰 20170329


global QMS_INSTANCE;

set(hObject, 'Value', true)
% 将代码进行设置
px_infos_ = cell(0, 8);
% 进行代码的扫描
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
                    entrust_amount = abs(entrust_amount);
                    px_info_ = cell(1, 8);
                    px_info_{1} = [ '<html><font color=#8B4513>', optQuote_.code, '</font></html>'];
                    px_info_{2} = 'call';
                    px_info_{3} = t;
                    px_info_{4} = optQuote_.K;
                    px_info_{5} = entrust_direction;
                    px_info_{6} = future_direction;
                    px_info_{7} = entrust_amount;
                    px_info_{8} = '';
                    px_infos_ = [px_infos_ ; px_info_];
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
                    entrust_amount = abs(entrust_amount);
                    px_info_ = cell(1, 8);
                    px_info_{1} = [ '<html><font color=#8B4513>', optQuote_.code, '</font></html>'];
                    px_info_{2} = 'put';
                    px_info_{3} = t;
                    px_info_{4} = optQuote_.K;
                    px_info_{5} = entrust_direction;
                    px_info_{6} = future_direction;
                    px_info_{7} = entrust_amount;
                    px_info_{8} = '';
                    px_infos_ = [px_infos_ ; px_info_];
                end   
            end
        end
        
    end
end
set(handles.sub_entrust.table_limitprice, 'Data' , px_infos_)
set(handles.sub_entrust.checkbox_mktprice, 'Value', false)









end