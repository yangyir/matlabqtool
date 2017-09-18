% ���ڵ��ڼ۸����(�㵽���յ�payoff)
function [ payoff ] = payoff_design_5(ST )
% ���ڵ��ڼ۸����(�㵽���յ�payoff)
    middle = 0.125;
    upper = 1;
    S0 = 1;
    a = 0.85 * S0;
    b = 1.15 * S0;
    T = 60;

    if(ST >= a && ST <= b)
        payoff = middle;
    elseif(ST > b)
        payoff = upper;
    else
        payoff = upper;
    end
end