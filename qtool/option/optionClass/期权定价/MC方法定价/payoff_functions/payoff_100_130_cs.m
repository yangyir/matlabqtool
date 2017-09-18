function [payoff] = payoff_100_130_cs(S)

K1 = 1;
K2 = 1.3;

ST = S(:, end);
% ÂòK1, ÂôK2
gain = max((ST - K1), 0);
pay = max((ST - K2),0);

payoff = gain - pay;
end