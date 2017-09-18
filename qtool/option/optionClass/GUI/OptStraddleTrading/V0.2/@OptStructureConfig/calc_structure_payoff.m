function [ curr_portfolio_payoff ] = calc_structure_payoff(self, price_level)
% 基于组合计算payoff
% wuyunfeng 20170331

s = self.s;
if isempty(s)
    curr_portfolio_payoff = nan;
    return;
end
if ~exist('price_level', 'var')
    price_level = self.curr_biaodi_axis_px;
end

% 计算组合资产的payoff
portfolio_T_idx = self.portfolio_T_idx;
portfolio_amt   = self.portfolio_amt;

% 判断时期是否是同期的组合
equal_datetime_        = length(unique(portfolio_T_idx)) == 1;
curr_portfolio_balance = self.curr_portfolio_balance;
% 相同时期
if equal_datetime_
    curr_portfolio_payoff = s.calcPayoff( price_level );
    curr_portfolio_payoff = curr_portfolio_payoff + curr_portfolio_balance;
else
% 不同时期
    % 如果是近月计算payoff,如果是远月计算delta_t的px
    min_T_idx     = min(portfolio_T_idx);
    m2tkCallQuote = self.m2tkCallQuote;
    yProps   = m2tkCallQuote.yProps;
    T_yProps = datenum(yProps);
    curr_portfolio_payoff = zeros(1, length(price_level));
    
    for t = 1:length(s.optInfos)
        optAmt_    = portfolio_amt(t);
        optQuote_  = s.optInfos(t);
        optPricer_ = s.optPricers(t);
        T_idx_     = portfolio_T_idx(t);
        if T_idx_ == min_T_idx
            curr_portfolio_payoff = curr_portfolio_payoff + optQuote_.calcPayoff(price_level) * optAmt_;
        else
            original_tau_  = optPricer_.tau;
            real_tau_      = (T_yProps(T_idx_) - T_yProps(min_T_idx)+1)/365;
            optPricer_.tau = real_tau_;
            optPricer_.S   = price_level;
            curr_portfolio_payoff = curr_portfolio_payoff + optPricer_.calcPx() * optAmt_;
            optPricer_.tau = original_tau_;
        end
    end
    curr_portfolio_payoff = curr_portfolio_payoff + curr_portfolio_balance;
end












end