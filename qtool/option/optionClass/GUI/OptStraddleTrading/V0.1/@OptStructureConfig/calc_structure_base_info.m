function calc_structure_base_info(self)
% ����ɱ��͵�ǰ��ϵ������ʽ𾻶��greeks
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

% ����curr_portfolio_balanceʹ�ö��ּ۸�
% curr_portfolio_costʹ��last�۸�
for t = 1:length( s.optInfos )
    optQuote_ = s.optInfos( t );
    optNum_   = s.num( t );
    
    if optNum_ > 0 % ѡ�������
        curr_portfolio_balance = -optNum_ * optQuote_.askP1 + curr_portfolio_balance - optNum_ * 3.6/1e4;
    else          % ѡ�������
        curr_portfolio_balance = -optNum_ * optQuote_.bidP1 + curr_portfolio_balance + optNum_ * 1.8/1e4;
    end
    
    % �����ʽ��ռ�ö��
    if optNum_ > 0
        curr_portfolio_cost = curr_portfolio_cost + optNum_ * optQuote_.last;
    else
        % ���ȼ��㱣֤��
        margin_money = optQuote_.margin( 'init' );
        curr_portfolio_cost = curr_portfolio_cost - optNum_ * margin_money + optNum_ * optQuote_.last;
    end

    % ����Greeks
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