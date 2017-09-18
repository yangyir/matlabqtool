function payoff = payoff_dual_opt_short_bin(ST)
 % ST 为到期价格
 % 看涨标的
% payoff 为二种情况：跌幅< 5% payoff = 1%;
% 跌幅>5%： payoff = 12%;
upper = 1;
middle = 1/12;

K1 = 0.95;

if ST < K1
    payoff = upper;
else
    payoff = middle;
end
end