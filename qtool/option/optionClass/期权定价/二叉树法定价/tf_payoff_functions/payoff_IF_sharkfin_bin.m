function payoff = payoff_IF_sharkfin_bin(ST)
 % ST 为到期价格
% 震荡市沪深三百指数期权
% payoff 为二种情况：涨幅 < 0% 或涨幅 > 15% payoff = 0%;
% 涨幅为0% ~ 15%： payoff = 涨幅;
S0 = 1;
upper = 1.15 * S0;

if ST > S0 && ST < upper
    payoff = ST - S0;
else
    payoff = 0;
end

end