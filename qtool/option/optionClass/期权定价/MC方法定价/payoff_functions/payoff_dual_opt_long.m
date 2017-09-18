function [payoff] = payoff_dual_opt_long(S)
% S 是一个序列
% payoff 为二种情况：涨幅< 5% payoff = 1%;
% 涨幅>5%： payoff = 12%;
upper = 1;
middle = 1/12;

S0 = 1;
K1 = 1.05;

ST = S(:, end);
payoff = ones(size(ST)) .* middle;
payoff(ST > K1) = upper;
end