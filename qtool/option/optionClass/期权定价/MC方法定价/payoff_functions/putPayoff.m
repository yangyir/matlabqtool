function [ payoff ] = putPayoff( S )
%PUTPAYOFF 

% 期权自身的参数
K = 1;

ST = S(:,end);

payoff = max( K - ST , 0);




end

