function [ payoff ] = callPayoff( S )

% 期权自身的参数
K = 1;

ST = S(:,end);

payoff = max(ST - K , 0);


end

