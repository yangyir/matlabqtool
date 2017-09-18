% 基于到期价格计算(算到期日的payoff)
function [ p ] = payoff_design_5_MC(S )
% 基于到期价格计算(算到期日的payoff)
    middle = 0.125;
    upper = 1;
    S0 = 1;
    a = 0.85 * S0;
    b = 1.15 * S0;
    T = 60;

    iterN = size(S,1);
    stepT = size(S,2);

    ST = S(:, end);

    p  = ones(iterN, 1);
    %     knock_out_count = 0;
    %     total_count = iterN;
    % case knock out:
    for i = 1:iterN
        if(ST(i) >= a && ST(i) <= b)
            p(i) = middle;
        elseif(ST(i) > b)
            p(i) = upper;
        else
            p(i) = upper;
        end
        
    end

end