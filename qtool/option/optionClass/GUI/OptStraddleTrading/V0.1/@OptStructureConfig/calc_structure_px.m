function [ curr_portfolio_px ] = calc_structure_px(self, price_level)
% 计算组合的px
% 吴云峰 20170331

s = self.s;
if isempty(s)
    curr_portfolio_px = nan;
    return;
end
if ~exist('price_level', 'var')
    price_level = self.curr_biaodi_axis_px;
end
curr_portfolio_balance = self.curr_portfolio_balance;

for t = 1:length(s.optInfos)
    s.optPricers(t).S = price_level;
end
curr_portfolio_px = s.calcPx();
curr_portfolio_px = curr_portfolio_px + curr_portfolio_balance;





end