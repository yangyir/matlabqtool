function payoff = payoff_IF_short_bin(ST)
 % ST 为到期价格
% 看跌沪深三百指数期权
% payoff 为三种情况：跌幅< 5% payoff = 0;
% 跌幅为5%~15%： payoff = 5%;
% 跌幅为15%以上：payoff = 15%;
upper = 1;
middle = 0.3333;
 S0 = 1;
K1 = 0.95;
K2 = 0.85;

if ST > K1
    payoff = 0;
elseif ST > K2
    payoff = middle;
else
    payoff = upper;
end
end