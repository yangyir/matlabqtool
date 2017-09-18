function [payoff] = payoff_IF_short(S)
% S 是一个序列
% 看跌沪深三百指数期权
% payoff 为三种情况：跌幅< 5% payoff = 0;
% 跌幅为5%~15%： payoff = 5%;
% 跌幅为15%以上：payoff = 15%;
upper = 1;
middle = 0.3333;
S0 = 1;
K1 = 0.95;
K2 = 0.85;


ST = S(:, end);

payoff = zeros(size(ST));

payoff(ST <= K1) = middle;
payoff(ST <= K2) = upper;


end