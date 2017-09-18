function payoff = payoff_IF_long_bin(ST)
 % ST Ϊ���ڼ۸�
 % ���ǻ�������ָ����Ȩ
% payoff Ϊ����������Ƿ�< 5% payoff = 0;
% �Ƿ�Ϊ5%~15%�� payoff = 5%;
% �Ƿ�Ϊ15%���ϣ�payoff = 15%;
 S0 = 1;
 upper = 1;
 middle = 0.3333;
K1 = 1.05;
K2 = 1.15;

if ST < K1
    payoff = 0;
elseif ST < K2
    payoff = middle;
else
    payoff = upper;
end
end