function [payoff] = payoff_IF_long(S)
% S 是一个序列
% 看涨沪深三百指数期权
% payoff 为三种情况：涨幅< 5% payoff = 0;
% 涨幅为5%~15%： payoff = 5%;
% 涨幅为15%以上：payoff = 15%;

upper = 1;
middle = 0.3333;

S0 = 1;
K1 = 1.05;
K2 = 1.15;


ST = S(:, end);

payoff = zeros(size(ST));

payoff(ST >= K1) = middle;
payoff(ST >= K2) = upper;


end