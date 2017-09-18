function [payoff] = payoff_IF_shock(S)
% S ��һ������
% ���л�������ָ����Ȩ
% payoff Ϊ������������< 5% payoff = 10%;
% ���Ϊ5% ~ 10%�� payoff = 4%;
% ���Ϊ10%���ϣ�payoff = 0;

S0 = 1;
upper = 10;
middle = 4;

high = max(S,[],2);
low = min(S,[],2);
range = (high - low)./low;

ST = S(:, end);

payoff = zeros(size(ST));

payoff(range < 0.1) = middle;
payoff(range < 0.05) = upper;


        
end