function load_historical_data(obj, historical_save_pathname)
% 提取historical_data
%{
输入: historical_save_pathname数据的保存路径
cd 或
'F:\myDriversFile\MyDriversMatlab\Mfiles12\optionStraddleTrading'
%}

% get path
if ~exist('historical_save_pathname', 'var')
    historical_save_pathname = [ pwd, '\historical\' ];
end
if isdir(historical_save_pathname)
    today_ = datestr(today, 'yyyymmdd');
    if historical_save_pathname(end) == '\'
        historical_save_path_ = [historical_save_pathname, today_, '\'];
    else
        historical_save_path_ = [historical_save_pathname, '\', today_, '\'];
    end
    if isdir(historical_save_path_)
        
        % load data
        historic_call_m2tk_ = obj.historic_call_m2tk_;
        historic_put_m2tk_  = obj.historic_put_m2tk_;
        [nT, nK] = size(historic_call_m2tk_.data);
        for t = 1:nT
            for k = 1:nK
                call_historic_ = historic_call_m2tk_.data(t, k);
                put_historic_  = historic_put_m2tk_.data(t, k);
                if call_historic_.is_obj_valid
                    stock_code_ = call_historic_.optCode;
                    save_filename_ = [historical_save_path_, stock_code_, '.mat'];
                    if exist(save_filename_, 'file')
                        load(save_filename_)
                        call_historic_.node = node;
                        str_ = sprintf('%s historical数据提取成功\r', stock_code_);
                        fprintf(str_);
                    end
                end
                if put_historic_.is_obj_valid
                    stock_code_ = put_historic_.optCode;
                    node        = put_historic_.node;
                    save_filename_ = [historical_save_path_, stock_code_, '.mat'];
                    if exist(save_filename_, 'file')
                        load(save_filename_)
                        put_historic_.node = node;
                        str_ = sprintf('%s historical数据提取成功\r', stock_code_);
                        fprintf(str_);
                    end
                end
            end
        end
        
    end
end




end