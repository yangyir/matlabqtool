function payoff = payoff_IF_same_bin(ST)
 % ST Ϊ���ڼ۸�
% ��ƽ��������ָ����Ȩ
% payoff Ϊ����������ǵ���> 5% payoff = 0;
% �ǵ���Ϊ5% ~ 1%�� payoff = 5%;
% �ǵ���Ϊ1%���ڣ�payoff = 10%;
upper = 1;
middle = 0.5;
 S0 = 1;
K1 = 0.05;
K2 = 0.01;

if abs(ST - S0) > K1
    payoff = 0;
elseif abs(ST - S0) > K2
    payoff = middle;
else
    payoff = upper;
end
end