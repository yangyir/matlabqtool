function [p ] = payoff_1( S )
% 输入量S是一个序列

T = size(S,2);

M = floor(T/2);

if M > 1.4 || M<0.95
    p = S(:,M).*S(:,M);
else
    p = max(S(end) - 1, 0 ) + S(end-1)/2;
end

end