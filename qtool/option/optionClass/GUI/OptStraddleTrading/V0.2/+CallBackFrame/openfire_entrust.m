function openfire_entrust(stra_, open_opt_table_, close_opt_table_, opposite_level_, guadan_level_, entrust_type_)
% 开火下单辅助函数
% entrust_type_ 1 全对手价 2 全挂 3 半对半挂
% wuyunfeng 20170415

global QMS_INSTANCE;
[nT, nK] = size(QMS_INSTANCE.callQuotes_.data);


for t = 1:nT
    for k = 1:nK
        % Call
        optCallQuote_ = QMS_INSTANCE.callQuotes_.data(t, k);
        % Put
        optPutQuote_  = QMS_INSTANCE.putQuotes_.data(t, k);
        if optCallQuote_.is_obj_valid
            
            % 填充委托信息
            entrust_info = struct('cp', [], 'opcl', [], 'amt', []);
            entrust_info(1) = [];
            
            open_call_entrust_amt = open_opt_table_{2*t-1, k};
            if isempty(open_call_entrust_amt),else
                open_call_entrust_amt = str2double(open_call_entrust_amt);
                if isnan(open_call_entrust_amt),else
                    entrust_info(end+1).cp   = 'call';
                    entrust_info(end).opcl = 'open';
                    entrust_info(end).amt  = open_call_entrust_amt;
                end
            end
                
            open_put_entrust_amt   = open_opt_table_{2*t,   k};
            if isempty(open_put_entrust_amt),else
                open_put_entrust_amt = str2double(open_put_entrust_amt);
                if isnan(open_put_entrust_amt),else
                    entrust_info(end+1).cp   = 'put';
                    entrust_info(end).opcl = 'open';
                    entrust_info(end).amt  = open_put_entrust_amt;
                end
            end
            
            close_call_entrust_amt = close_opt_table_{2*t-1, k};
            if isempty(close_call_entrust_amt),else
                close_call_entrust_amt = str2double(close_call_entrust_amt);
                if isnan(close_call_entrust_amt),else
                    entrust_info(end+1).cp   = 'call';
                    entrust_info(end).opcl = 'close';
                    entrust_info(end).amt  = close_call_entrust_amt;
                end
            end
            
            close_put_entrust_amt  = close_opt_table_{2*t,   k};
            if isempty(close_put_entrust_amt),else
                close_put_entrust_amt = str2double(close_put_entrust_amt);
                if isnan(close_put_entrust_amt),else
                    entrust_info(end+1).cp   = 'put';
                    entrust_info(end).opcl = 'close';
                    entrust_info(end).amt  = close_put_entrust_amt;
                end
            end
            
            if isempty(entrust_info)
                continue;
            end
                        
            for e = 1:length(entrust_info)
                entrust_amt = entrust_info(e).amt;
                if abs(entrust_amt) < 0.01
                    continue;
                end
                cp = entrust_info(e).cp;
                if strcmp(cp, 'call')
                    optQuote_ = optCallQuote_;
                else
                    optQuote_ = optPutQuote_;
                end
                opcl = entrust_info(e).opcl;
                if entrust_amt > 0
                    entrust_direction = '1';
                else
                    entrust_direction = '2';
                end
                entrust_amt = abs(entrust_amt);
                if strcmp(opcl, 'open')
                    future_direction  = '1';
                else
                    future_direction  = '2';
                end
                optQuote_.fillQuote;
                switch entrust_type_
                    case 1 % 全对手价
                        entrust_px = get_opposite_price(optQuote_, opposite_level_, entrust_direction);
                        if entrust_px
                            stra_.set_opt(t, optQuote_.K, cp);
                            stra_.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                        end
                    case 2 % 全挂
                        entrust_px = get_guadan_price(optQuote_, guadan_level_, entrust_direction);
                        if entrust_px
                            stra_.set_opt(t, optQuote_.K, cp);
                            stra_.place_entrust_opt(entrust_direction, entrust_amt, future_direction, entrust_px);
                        end
                    case 3 % 半对半挂
                        entrust_oppo_px = get_opposite_price(optQuote_, opposite_level_, entrust_direction);
                        entrust_guad_px = get_guadan_price(optQuote_, guadan_level_, entrust_direction);
                        oppo_amt = round(entrust_amt/2);
                        guad_amt = entrust_amt - oppo_amt;
                        stra_.set_opt(t, optQuote_.K, cp);
                        if oppo_amt > 0
                            if entrust_oppo_px
                                stra_.place_entrust_opt(entrust_direction, oppo_amt, future_direction, entrust_oppo_px);
                            end
                        end
                        if guad_amt > 0
                            if entrust_guad_px
                                stra_.place_entrust_opt(entrust_direction, guad_amt, future_direction, entrust_guad_px);
                            end
                        end
                end
            end
            % for e = 1:length(entrust_info)
        end
    end
end




end

function px = get_opposite_price(optQuote_, mktlevel, entrust_direction)

% 买
if entrust_direction == '1'
    switch mktlevel
        case 0, px = optQuote_.last;
        case 1, px = optQuote_.askP1;
        case 2, px = optQuote_.askP2;
        case 3, px = optQuote_.askP3;
        case 4, px = optQuote_.askP4;
        case 5, px = optQuote_.askP5;
        otherwise, px = optQuote_.last;
    end       
% 卖    
else
    switch mktlevel
        case 0, px = optQuote_.last;
        case 1, px = optQuote_.bidP1;
        case 2, px = optQuote_.bidP2;
        case 3, px = optQuote_.bidP3;
        case 4, px = optQuote_.bidP4;
        case 5, px = optQuote_.bidP5;
        otherwise, px = optQuote_.last;
    end  
end


end

function px = get_guadan_price(optQuote_, mktlevel, entrust_direction)

% 买
if entrust_direction == '1'
    switch mktlevel
        case 0, px = optQuote_.last;
        case 1, px = optQuote_.bidP1;
        case 2, px = optQuote_.bidP2;
        case 3, px = optQuote_.bidP3;
        case 4, px = optQuote_.bidP4;
        case 5, px = optQuote_.bidP5;
        otherwise, px = optQuote_.last;
    end       
% 卖    
else
    switch mktlevel
        case 0, px = optQuote_.last;
        case 1, px = optQuote_.askP1;
        case 2, px = optQuote_.askP2;
        case 3, px = optQuote_.askP3;
        case 4, px = optQuote_.askP4;
        case 5, px = optQuote_.askP5;
        otherwise, px = optQuote_.last;
    end  
end


end