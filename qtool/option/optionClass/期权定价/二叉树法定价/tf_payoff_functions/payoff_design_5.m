% 基于到期价格计算(算到期日的payoff)
function [ payoff ] = payoff_design_5(ST )
% 基于到期价格计算(算到期日的payoff)
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