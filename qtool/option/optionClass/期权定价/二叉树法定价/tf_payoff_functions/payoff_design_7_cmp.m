% ���ڵ��ڼ۸����(�㵽���յ�payoff)
function [ payoff ] = payoff_design_7_cmp(ST )
% ���ڵ��ڼ۸����(�㵽���յ�payoff)
    middle = 0.3333;
    upper = 1;
    S0 = 1;
    a = S0;
    b = 1.15 * S0;
    T = 90;

    if(ST >= a && ST <= b)
        payoff = 1/(b-a) * (ST - a);
    elseif(ST > b)
        payoff = middle;
    else
        payoff = 0;
    end
end