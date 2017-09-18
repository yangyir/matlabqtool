function calc_structure_base_info(self)
% 计算成本和当前组合的买卖资金净额和greeks
% curr_portfolio_cost
% curr_portfolio_balance
% curr_portfolio_greeks
% wuyunfeng 20170330

s = self.s;
if isempty(s)
    return;
end

curr_portfolio_cost    = 0;
curr_portfolio_balance = 0;
port_info = struct('code', [], ...
    'amt', [], ...
    'px',  [], ...
    'iv',  [], ...
    'delta', [], ...
    'gamma', [], ...
    'vega',  [], ...
    'theta', []);   
curr_portfolio_greeks    = port_info;
curr_portfolio_greeks(1) = [];

delta_  = 0;
gamma_  = 0;
vega_   = 0;
theta_  = 0;
px_     = 0;
impvol_ = 0;

% 计算curr_portfolio_balance使用对手价格
% curr_portfolio_cost使用last价格
for t = 1:length( s.optInfos )
    optQuote_ = s.optInfos( t );
    optNum_   = s.num( t );
    
    if optNum_ > 0 % 选择的是买
        curr_portfolio_balance = -optNum_ * optQuote_.askP1 + curr_portfolio_balance - optNum_ * 3.6/1e4;
    else          % 选择的是卖
        curr_portfolio_balance = -optNum_ * optQuote_.bidP1 + curr_portfolio_balance + optNum_ * 1.8/1e4;
    end
    
    % 计算资金的占用额度
    if optNum_ > 0
        curr_portfolio_cost = curr_portfolio_cost + optNum_ * optQuote_.last;
    else
        % 首先计算保证金
        margin_money = optQuote_.margin( 'init' );
        curr_portfolio_cost = curr_portfolio_cost - optNum_ * margin_money + optNum_ * optQuote_.last;
    end

    % 填充信息
    portfolio_info_ = port_info;
    portfolio_info_.code  = optQuote_.code;
    portfolio_info_.amt   = optNum_;
    portfolio_info_.px    = optQuote_.last;
    portfolio_info_.iv    = optQuote_.impvol;
    portfolio_info_.delta = optQuote_.delta * optQuote_.multiplier * optQuote_.S/100.0;
    portfolio_info_.gamma = optQuote_.gamma * optQuote_.multiplier * 0.5 * (optQuote_.S/100.0)^2;
    portfolio_info_.vega  = optQuote_.vega  * optQuote_.multiplier / 100;
    portfolio_info_.theta = optQuote_.theta * optQuote_.multiplier / 360.0;
    
    curr_portfolio_greeks(end+1) = portfolio_info_;
    
    delta_ = delta_ + portfolio_info_.delta * optNum_;
    gamma_ = gamma_ + portfolio_info_.gamma * optNum_;
    vega_  = vega_  + portfolio_info_.vega  * optNum_;
    theta_ = theta_ + portfolio_info_.theta * optNum_;
    px_     = px_     + optQuote_.last   * optNum_;
    impvol_ = impvol_ + optQuote_.impvol * optNum_;
    
    
end

% 信息的汇总
portfolio_info_ = port_info;
portfolio_info_.delta = delta_;
portfolio_info_.gamma = gamma_;
portfolio_info_.vega  = vega_;
portfolio_info_.theta = theta_;
portfolio_info_.code  = '汇总';
portfolio_info_.amt   = 0;
portfolio_info_.px    = px_;
portfolio_info_.iv    = impvol_;
curr_portfolio_greeks(end+1) = portfolio_info_;


self.curr_portfolio_cost     = curr_portfolio_cost; 
self.curr_portfolio_balance  = curr_portfolio_balance;  
self.curr_portfolio_greeks   = curr_portfolio_greeks;








end