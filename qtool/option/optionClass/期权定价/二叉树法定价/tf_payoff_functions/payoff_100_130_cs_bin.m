function [payoff] = payoff_100_130_cs_bin(ST)

K1 = 1;
K2 = 1.3;

gain = max(ST - K1, zeros(size(ST)) );
pay = max(ST - K2, zeros(size(ST)) );

payoff = gain - pay;

end