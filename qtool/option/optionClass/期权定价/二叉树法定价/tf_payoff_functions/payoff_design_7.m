% 基于到期价格计算(算到期日的payoff)
function [ payoff ] = payoff_design_7(ST )
% 基于到期价格计算(算到期日的payoff)
    middle = 0.3333;
    upper = 1;
    S0 = 1;
    a = 0.85 * S0;
    b = S0;
    T = 90;

    if(ST >= a && ST <= b)
        payoff = (-1) * 1/(b-a) * (ST - a) + 1;
    elseif(ST < a)
        payoff = middle;
    else
        payoff = 0;
    end
end