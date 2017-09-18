function [payoff] = payoff_dual_opt_short(S)
% S 是一个序列
% payoff 为二种情况：跌幅< 5% payoff = 1%;
% 跌幅>5%： payoff = 12%;
upper = 1;
middle = 1/12;

S0 = 1;
K1 = 0.95;

ST = S(:, end);
payoff = ones(size(ST)) .* middle;
payoff(ST < K1) = upper;
end