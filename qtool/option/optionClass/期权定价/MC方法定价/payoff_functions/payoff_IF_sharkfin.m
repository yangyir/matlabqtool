function [payoff] = payoff_IF_sharkfin(S)
% S ��һ������
% ���л�������ָ����Ȩ
% payoff Ϊ����������Ƿ� < 0% ���Ƿ� > 15% payoff = 0%;
% �Ƿ�Ϊ0% ~ 15%�� payoff = �Ƿ�;


S0 = 1;
upper = 1.15 * S0;

ST = S(:, end);

payoff = ST - S0;

payoff(((ST < S0) | (ST > upper))) = 0;
end