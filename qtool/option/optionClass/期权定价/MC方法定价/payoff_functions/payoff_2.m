function [ p ] = payoff_2( S )
% S «–Ú¡–

p = (S(end) - S(end-1)) * S(1);


end

