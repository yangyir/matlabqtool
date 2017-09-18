function [payoff] = payoff_dual_opt_short(S)
% S ��һ������
% payoff Ϊ�������������< 5% payoff = 1%;
% ����>5%�� payoff = 12%;
upper = 1;
middle = 1/12;

S0 = 1;
K1 = 0.95;

ST = S(:, end);
payoff = ones(size(ST)) .* middle;
payoff(ST < K1) = upper;
end