function payoff = payoff_IF_short_bin(ST)
 % ST Ϊ���ڼ۸�
% ������������ָ����Ȩ
% payoff Ϊ�������������< 5% payoff = 0;
% ����Ϊ5%~15%�� payoff = 5%;
% ����Ϊ15%���ϣ�payoff = 15%;
upper = 1;
middle = 0.3333;
 S0 = 1;
K1 = 0.95;
K2 = 0.85;

if ST > K1
    payoff = 0;
elseif ST > K2
    payoff = middle;
else
    payoff = upper;
end
end