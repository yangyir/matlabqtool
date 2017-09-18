function [payoff] = payoff_IF_short(S)
% S ��һ������
% ������������ָ����Ȩ
% payoff Ϊ�������������< 5% payoff = 0;
% ����Ϊ5%~15%�� payoff = 5%;
% ����Ϊ15%���ϣ�payoff = 15%;
upper = 1;
middle = 0.3333;
S0 = 1;
K1 = 0.95;
K2 = 0.85;


ST = S(:, end);

payoff = zeros(size(ST));

payoff(ST <= K1) = middle;
payoff(ST <= K2) = upper;


end