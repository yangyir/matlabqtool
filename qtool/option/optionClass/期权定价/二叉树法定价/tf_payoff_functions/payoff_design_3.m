% 基于到期价格计算(算到期日的payoff)
function [ payoff ] = payoff_design_3(ST )
% 基于到期价格计算(算到期日的payoff)
    upper = 1;
    S0 = 1;
    a = 0.95 * S0;
    b = 1.05 * S0;
    T = 60;

    if(ST >= a && ST < S0)
        payoff = 1/(S0 - a) * (ST - a);
    elseif(ST >= S0 && ST <= b)
        payoff = (-1) * 1/(b - S0) * (ST - S0) + upper;
    else
        payoff = 0;
    end
end