function [ payoff ] = putPayoff( S )
%PUTPAYOFF 

% ��Ȩ����Ĳ���
K = 1;

ST = S(:,end);

payoff = max( K - ST , 0);




end

