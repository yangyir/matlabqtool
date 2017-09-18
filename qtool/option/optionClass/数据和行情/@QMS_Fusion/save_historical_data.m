function save_historical_data(obj, historical_save_pathname)
% 保存historical_data
%{
输入: historical_save_pathname数据的保存路径
cd 或
'F:\myDriversFile\MyDriversMatlab\Mfiles12\optionStraddleTrading'
%}

if ~exist('historical_save_pathname', 'var')
    historical_save_pathname = [ pwd, '\historical\' ];
end

% create path
if isdir(historical_save_pathname)
else
    mkdir(historical_save_pathname)
end
today_ = datestr(today, 'yyyymmdd');
if historical_save_pathname(end) == '\'
    historical_save_path_ = [historical_save_pathname, today_, '\'];
else
    historical_save_path_ = [historical_save_pathname, '\', today_, '\'];
end
if isdir(historical_save_path_)
else
    mkdir(historical_save_path_)
end

% savedata
historic_call_m2tk_ = obj.historic_call_m2tk_;
historic_put_m2tk_  = obj.historic_put_m2tk_;
[nT, nK] = size(historic_call_m2tk_.data);
for t = 1:nT
    for k = 1:nK
        call_historic_ = historic_call_m2tk_.data(t, k);
        put_historic_  = historic_put_m2tk_.data(t, k);
        if call_historic_.is_obj_valid
            stock_code_ = call_historic_.optCode;
            node        = call_historic_.node;
            save_filename_ = [historical_save_path_, stock_code_, '.mat'];
            save(save_filename_, 'node')
            str_ = sprintf('%s historical数据保存成功\r', stock_code_);
            fprintf(str_);
        end
        if put_historic_.is_obj_valid
            stock_code_ = put_historic_.optCode;
            node        = put_historic_.node;
            save_filename_ = [historical_save_path_, stock_code_, '.mat'];
            save(save_filename_, 'node')
            str_ = sprintf('%s historical数据保存成功\r', stock_code_);
            fprintf(str_);
        end
    end
end






end