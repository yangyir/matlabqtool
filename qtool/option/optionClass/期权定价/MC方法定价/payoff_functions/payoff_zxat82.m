function [ payoff ] = payoff_zxat82( S )
%PAYOFF_ZXAT82 ÖÐÐÅ°²Ì©82ºÅ
%   Detailed explanation goes here

ST = S(:,end);

payoff = zeros( size(ST));

payoff(ST<=1) = 0;
payoff(ST>1.12) = 0.31;

try 
payoff(ST>1 & ST <= 1.12) = 1/0.12 * (ST-1);
catch e
end


end

