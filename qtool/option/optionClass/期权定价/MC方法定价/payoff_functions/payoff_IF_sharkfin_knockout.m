function [payoff] = payoff_IF_sharkfin_knockout(S)
% S 是一个序列
% 震荡市沪深三百指数期权
% payoff 为二种情况：涨幅 < 0% 或涨幅 > 15% payoff = 0%;
% 涨幅为0% ~ 15%： payoff = 涨幅;
% 如果波动超出0%到15%范围，敲出，收益为0;

S0 = 1;
upper = 1.15 * S0;

ST = S(:, end);

% Smin = min(S, [], 2);
Smax = max(S, [], 2);

payoff = ST - S0;

payoff(((ST < S0) | (ST > upper))) = 0;

% payoff(Smin < S0) = 0;
payoff(Smax > upper) = 0;
end