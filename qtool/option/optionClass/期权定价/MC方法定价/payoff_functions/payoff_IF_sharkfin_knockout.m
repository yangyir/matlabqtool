function [payoff] = payoff_IF_sharkfin_knockout(S)
% S ��һ������
% ���л�������ָ����Ȩ
% payoff Ϊ����������Ƿ� < 0% ���Ƿ� > 15% payoff = 0%;
% �Ƿ�Ϊ0% ~ 15%�� payoff = �Ƿ�;
% �����������0%��15%��Χ���ó�������Ϊ0;

S0 = 1;
upper = 1.15 * S0;

ST = S(:, end);

% Smin = min(S, [], 2);
Smax = max(S, [], 2);

payoff = ST - S0;

payoff(((ST < S0) | (ST > upper))) = 0;

% payoff(Smin < S0) = 0;
payoff(Smax > upper) = 0;
end