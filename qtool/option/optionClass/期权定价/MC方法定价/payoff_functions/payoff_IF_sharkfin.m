function [payoff] = payoff_IF_sharkfin(S)
% S 是一个序列
% 震荡市沪深三百指数期权
% payoff 为二种情况：涨幅 < 0% 或涨幅 > 15% payoff = 0%;
% 涨幅为0% ~ 15%： payoff = 涨幅;


S0 = 1;
upper = 1.15 * S0;

ST = S(:, end);

payoff = ST - S0;

payoff(((ST < S0) | (ST > upper))) = 0;
end