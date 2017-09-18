function sub_entrust_button_payoffplot(hObject, eventdata, handles)
% 子界面的作图画Payoff
% 吴云峰 20170331

global OPTSTRUCTURE_INSTANCE;
global QMS_INSTANCE;
opt_entrustinfo_ = get(handles.sub_entrust.table_optcode, 'Data');

% 更新数据
curr_biaodi_px  = nan;        
portfolio_T_idx = [];         
portfolio_K_idx = [];          
portfolio_amt   = [];         
portfolio_CPs   = {};        
[nT, nK] = size(QMS_INSTANCE.callQuotes_.data);


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
            entrust_amount = opt_entrustinfo_{k, 6*t-2};
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

if isempty(portfolio_amt)
else
    OPTSTRUCTURE_INSTANCE.curr_biaodi_px  = curr_biaodi_px;
    OPTSTRUCTURE_INSTANCE.portfolio_T_idx = portfolio_T_idx;
    OPTSTRUCTURE_INSTANCE.portfolio_K_idx = portfolio_K_idx;
    OPTSTRUCTURE_INSTANCE.portfolio_amt   = portfolio_amt;
    OPTSTRUCTURE_INSTANCE.portfolio_CPs   = portfolio_CPs;
    OPTSTRUCTURE_INSTANCE.calc_plot_payoff;
end









end