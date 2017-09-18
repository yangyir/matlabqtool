function [payoff] = payoff_IF_shock(S)
% S 是一个序列
% 震荡市沪深三百指数期权
% payoff 为三种情况：振幅< 5% payoff = 10%;
% 振幅为5% ~ 10%： payoff = 4%;
% 振幅为10%以上：payoff = 0;

S0 = 1;
upper = 10;
middle = 4;

high = max(S,[],2);
low = min(S,[],2);
range = (high - low)./low;

ST = S(:, end);

payoff = zeros(size(ST));

payoff(range < 0.1) = middle;
payoff(range < 0.05) = upper;


        
end