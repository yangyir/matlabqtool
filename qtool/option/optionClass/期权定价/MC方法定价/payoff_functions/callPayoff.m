function [ payoff ] = callPayoff( S )

% ��Ȩ����Ĳ���
K = 1;

ST = S(:,end);

payoff = max(ST - K , 0);


end

