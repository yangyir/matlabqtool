function payoff = payoff_IF_long_bin(ST)
 % ST 为到期价格
 % 看涨沪深三百指数期权
% payoff 为三种情况：涨幅< 5% payoff = 0;
% 涨幅为5%~15%： payoff = 5%;
% 涨幅为15%以上：payoff = 15%;
 S0 = 1;
 upper = 1;
 middle = 0.3333;
K1 = 1.05;
K2 = 1.15;

if ST < K1
    payoff = 0;
elseif ST < K2
    payoff = middle;
else
    payoff = upper;
end
end