% ���ڵ��ڼ۸����(�㵽���յ�payoff)
function [ payoff ] = payoff_design_1_put(ST )
% ���ڵ��ڼ۸����(�㵽���յ�payoff)
    middle = 0.5;
    upper = 1;
    S0 = 1;
    a = 0.8 * S0;
    b = 0.9 * S0;
    T = 30;

    if(ST < a)
        payoff = upper;
    elseif(ST > b)
        payoff = 0;
    else
        payoff = middle;
    end
end