function payoff = payoff_dual_opt_long_bin(ST)
 % ST Ϊ���ڼ۸�
 % ���Ǳ��
% payoff Ϊ����������Ƿ�< 5% payoff = 1%;
% �Ƿ�>5%�� payoff = 12%;
upper = 1;
middle = 1/12;

K1 = 1.05;

if ST > K1
    payoff = upper;
else
    payoff = middle;
end
end