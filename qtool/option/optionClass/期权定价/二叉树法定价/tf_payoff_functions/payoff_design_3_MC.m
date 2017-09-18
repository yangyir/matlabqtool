% 基于到期价格计算(算到期日的payoff)
function [ p ] = payoff_design_3_MC(S )
% 基于到期价格计算(算到期日的payoff)
    upper = 1;
    S0 = 1;
    a = 0.95 * S0;
    b = 1.05 * S0;
    T = 30;
    iterN = size(S,1);
    stepT = size(S,2);

    ST = S(:, end);

    p  = ones(iterN, 1);
    %     knock_out_count = 0;
    %     total_count = iterN;
    % case knock out:
    for i = 1:iterN
        if( ST(i) >= a && ST(i) < S0 ) % case 1
            p(i) = 1/(S0 - a) * (ST(i) - a);
        elseif(ST(i) >= S0 && ST(i) <= b)
            p(i) = ((-1) * 1/(b - S0) * (ST(i) - S0) + upper);
        else
            p(i) = 0;
        end

    end

end