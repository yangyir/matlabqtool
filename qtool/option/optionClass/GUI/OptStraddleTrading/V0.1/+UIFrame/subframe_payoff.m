function sub_payoff = subframe_payoff(parent)
% 单账户管理-组合损益作图
%sub_single_sub_payoff = subframe_single_subframe_payoff(parent)
% 吴云峰 230170318


sub_payoff.parent = parent;
% payoff的作图句柄
sub_payoff.axes_payoff = axes('Parent', parent, 'Units', 'Normalized', ...
    'Position', [0.07 0.08 0.9 0.85], 'FontSize' , 9 , 'FontWeight' ,'bold');






end