function sub_payoff = subframe_payoff(parent)
% ���˻�����-���������ͼ
%sub_single_sub_payoff = subframe_single_subframe_payoff(parent)
% ���Ʒ� 230170318


sub_payoff.parent = parent;
% payoff����ͼ���
sub_payoff.axes_payoff = axes('Parent', parent, 'Units', 'Normalized', ...
    'Position', [0.07 0.08 0.9 0.85], 'FontSize' , 9 , 'FontWeight' ,'bold');






end