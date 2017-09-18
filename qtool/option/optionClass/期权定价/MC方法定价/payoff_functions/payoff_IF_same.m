function [payoff] = payoff_IF_same(S)
% S ��һ������
% ��ƽ��������ָ����Ȩ
% payoff Ϊ����������ǵ���> 5% payoff = 0;
% �ǵ���Ϊ5% ~ 1%�� payoff = 5%;
% �ǵ���Ϊ1%���ڣ�payoff = 10%;

upper = 1;
middle = 0.5;

S0 = 1;
K1 = 0.05;
K2 = 0.01;


ST = S(:, end);

payoff = zeros(size(ST));

payoff(abs(ST - S0) < K2) = upper;
payoff(abs(ST - S0) <= K1) = middle;
end