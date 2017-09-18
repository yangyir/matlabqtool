function [payoff] = payoff_IF_long(S)
% S ��һ������
% ���ǻ�������ָ����Ȩ
% payoff Ϊ����������Ƿ�< 5% payoff = 0;
% �Ƿ�Ϊ5%~15%�� payoff = 5%;
% �Ƿ�Ϊ15%���ϣ�payoff = 15%;

upper = 1;
middle = 0.3333;

S0 = 1;
K1 = 1.05;
K2 = 1.15;


ST = S(:, end);

payoff = zeros(size(ST));

payoff(ST >= K1) = middle;
payoff(ST >= K2) = upper;


end