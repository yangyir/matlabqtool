function payoff = payoff_dual_opt_short_bin(ST)
 % ST Ϊ���ڼ۸�
 % ���Ǳ��
% payoff Ϊ�������������< 5% payoff = 1%;
% ����>5%�� payoff = 12%;
upper = 1;
middle = 1/12;

K1 = 0.95;

if ST < K1
    payoff = upper;
else
    payoff = middle;
end
end