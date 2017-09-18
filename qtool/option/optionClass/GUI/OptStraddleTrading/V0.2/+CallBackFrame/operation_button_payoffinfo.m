function operation_button_payoffinfo(hObject, eventdata, handles)
% 子界面的作图画Payoff
% 吴云峰 20170331

global OPTSTRUCTURE_INSTANCE;
global QMS_INSTANCE;
opt_entrustinfo_ = get(handles.asset.table_optopensel, 'Data');

% 更新数据
curr_biaodi_px  = nan;        
portfolio_T_idx = [];         
portfolio_K_idx = [];          
portfolio_amt   = [];         
portfolio_CPs   = {};        
[nT, nK] = size(QMS_INSTANCE.callQuotes_.data);

% min max interval
minpx    = str2double(get(handles.payofffig.edit_minpx, 'String'));
maxpx    = str2double(get(handles.payofffig.edit_maxpx, 'String'));
interval = str2double(get(handles.payofffig.edit_interval, 'String'));

for t = 1:nT
    for k = 1:nK
        
        % Call
        optQuote_ = QMS_INSTANCE.callQuotes_.data(t, k);
        if optQuote_.is_obj_valid
            entrust_amount = opt_entrustinfo_{2*t-1, k};
            if isempty(entrust_amount)
            else
                entrust_amount = str2double(entrust_amount);
                if isnan(entrust_amount)
                else
                    portfolio_T_idx = [portfolio_T_idx, t];
                    portfolio_K_idx = [portfolio_K_idx, k];
                    portfolio_CPs   = [portfolio_CPs, optQuote_.CP];
                    portfolio_amt   = [portfolio_amt, entrust_amount];
                    curr_biaodi_px  = optQuote_.S;
                end
            end
        end
        
        % Put
        optQuote_ = QMS_INSTANCE.putQuotes_.data(t, k);
        if optQuote_.is_obj_valid
            entrust_amount = opt_entrustinfo_{2*t, k};
            if isempty(entrust_amount)
            else
                entrust_amount = str2double(entrust_amount);
                if isnan(entrust_amount)
                else
                    portfolio_T_idx = [portfolio_T_idx, t];
                    portfolio_K_idx = [portfolio_K_idx, k];
                    portfolio_CPs   = [portfolio_CPs, optQuote_.CP];
                    portfolio_amt   = [portfolio_amt, entrust_amount];
                    curr_biaodi_px  = optQuote_.S;
                end
            end
        end
        
    end
end

OPTSTRUCTURE_INSTANCE.curr_biaodi_px  = curr_biaodi_px;
OPTSTRUCTURE_INSTANCE.portfolio_T_idx = portfolio_T_idx;
OPTSTRUCTURE_INSTANCE.portfolio_K_idx = portfolio_K_idx;
OPTSTRUCTURE_INSTANCE.portfolio_amt   = portfolio_amt;
OPTSTRUCTURE_INSTANCE.portfolio_CPs   = portfolio_CPs;
OPTSTRUCTURE_INSTANCE.calc_plot_payoff(minpx, maxpx, interval);

% 信息的界面展示
if isempty(portfolio_amt)
    set(handles.payofffig.table_greeks, 'Data', cell(0, 8))
else
     curr_portfolio_greeks = OPTSTRUCTURE_INSTANCE.curr_portfolio_greeks;
     fieldnames_ = fieldnames(curr_portfolio_greeks);
     len_port    = length(portfolio_amt)+1;
     len_field   = length(fieldnames_);
     disp_data = cell(len_port, len_field);
     for n = 1:len_port
         for f = 1:len_field
             feature_ = curr_portfolio_greeks(n).(fieldnames_{f});
             if ischar(feature_)
                 disp_data{n ,f} = feature_;
             else
                 if ismember(fieldnames_{f}, {'amt'})
                     disp_data{n ,f} = num2str(feature_);
                 elseif ismember(fieldnames_{f}, {'px','iv'})
                     disp_data{n ,f} = sprintf('%.4f', feature_);
                 else
                     disp_data{n ,f} = sprintf('%.2f', feature_);
                 end
             end
         end
     end
     set(handles.payofffig.table_greeks, 'Data', disp_data)
end









end