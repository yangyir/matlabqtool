function payoff = payoff_IF_sharkfin_bin(ST)
 % ST Ϊ���ڼ۸�
% ���л�������ָ����Ȩ
% payoff Ϊ����������Ƿ� < 0% ���Ƿ� > 15% payoff = 0%;
% �Ƿ�Ϊ0% ~ 15%�� payoff = �Ƿ�;
S0 = 1;
upper = 1.15 * S0;

if ST > S0 && ST < upper
    payoff = ST - S0;
else
    payoff = 0;
end

end