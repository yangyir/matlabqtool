% 基于到期价格计算(算到期日的payoff)
function [ payoff ] = payoff_design_2(ST )
% 基于到期价格计算(算到期日的payoff)
    middle = 0.5;
    upper = 1;
    S0 = 1;
    a = 1.1 * S0;
    b = 1.15 * S0;
    T = 30;

    if(ST >= a && ST < b)
        payoff = 1/(b - a) * (ST - a) + middle;
    elseif(ST >= b)
        payoff = upper;
    else
        payoff = 0;
    end
end