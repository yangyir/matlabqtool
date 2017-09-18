function calc_recently_residual_days(self)
% 计算未来交易的天数
% wuyunfeng 20170330

portfolio_T_idx = self.portfolio_T_idx;
min_expire_idx  = min(portfolio_T_idx);
m2tkCallQuote   = self.m2tkCallQuote;

yProps = m2tkCallQuote.yProps;
min_expire_date = datenum(yProps{min_expire_idx});

recently_residual_days = min_expire_date - today + 1;
self.recently_residual_days = recently_residual_days;




end