function payoff = payoff_dual_opt_long_bin(ST)
 % ST 为到期价格
 % 看涨标的
% payoff 为二种情况：涨幅< 5% payoff = 1%;
% 涨幅>5%： payoff = 12%;
upper = 1;
middle = 1/12;

K1 = 1.05;

if ST > K1
    payoff = upper;
else
    payoff = middle;
end
end