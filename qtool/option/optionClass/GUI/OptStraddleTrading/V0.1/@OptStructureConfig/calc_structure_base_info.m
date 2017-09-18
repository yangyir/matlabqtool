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

curr_portfolio_cost         = 0;
curr_portfolio_balance      = 0;
curr_portfolio_greeks.delta = 0;
curr_portfolio_greeks.gamma = 0;
curr_portfolio_greeks.vega  = 0;
curr_portfolio_greeks.theta = 0;
curr_portfolio_greeks.rho   = 0;

delta_ = 0;
gamma_ = 0;
vega_  = 0;
theta_ = 0;
rho_   = 0;

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

    % 计算Greeks
    delta_ = delta_ + optQuote_.delta * optNum_;
    gamma_ = gamma_ + optQuote_.gamma * optNum_;
    theta_ = theta_ + optQuote_.theta * optNum_;
    vega_  = vega_  + optQuote_.vega  * optNum_;
    rho_   = rho_   + optQuote_.rho   * optNum_;
    
end

curr_portfolio_greeks.delta = delta_;
curr_portfolio_greeks.gamma = gamma_;
curr_portfolio_greeks.vega  = vega_;
curr_portfolio_greeks.theta = theta_;
curr_portfolio_greeks.rho   = rho_;


self.curr_portfolio_cost    = curr_portfolio_cost; 
self.curr_portfolio_balance = curr_portfolio_balance;  
self.curr_portfolio_greeks  = curr_portfolio_greeks;








end