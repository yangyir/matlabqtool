% 基于到期价格计算(算到期日的payoff)
function [ p ] = payoff_design_6_MC(S )
% 基于到期价格计算(算到期日的payoff)
    middle = 0.33333;
    upper = 1;
    S0 = 1;
    a = S0;
    b = 1.15 * S0;
    T = 30;
    iterN = size(S,1);
    stepT = size(S,2);

    ST = S(:, end);

    p  = ones(iterN, 1);
    %     knock_out_count = 0;
    %     total_count = iterN;
    % case knock out:
    for i = 1:iterN
        if(ST(i) >= a && ST(i) <= b)
            p(i) = 1/(b-a) * (ST(i) - a);
        elseif(ST(i) > b)
            p(i) = middle;
        else
            p(i) = 0;
        end
        
    end
    
end