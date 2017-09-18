function [payoff] = payoff_IF_same(S)
% S 是一个序列
% 看平沪深三百指数期权
% payoff 为三种情况：涨跌幅> 5% payoff = 0;
% 涨跌幅为5% ~ 1%： payoff = 5%;
% 涨跌幅为1%以内：payoff = 10%;

upper = 1;
middle = 0.5;

S0 = 1;
K1 = 0.05;
K2 = 0.01;


ST = S(:, end);

payoff = zeros(size(ST));

payoff(abs(ST - S0) < K2) = upper;
payoff(abs(ST - S0) <= K1) = middle;
end