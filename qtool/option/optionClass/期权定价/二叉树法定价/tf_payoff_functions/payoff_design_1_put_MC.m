% 基于到期价格计算(算到期日的payoff)
function [ p ] = payoff_design_1_put_MC(S )
% 基于到期价格计算(算到期日的payoff)
    middle = 0.5;
    upper = 1;
    S0 = 1;
    a = 0.8 * S0;
    b = 0.9 * S0;
    T = 30;
    iterN = size(S,1);
    stepT = size(S,2);

    ST = S(:, end);

    p  = ones(iterN, 1);
    %     knock_out_count = 0;
    %     total_count = iterN;
    % case knock out:
    for i = 1:iterN
        if(ST(i) < a)
            p(i) = upper;
        elseif(ST(i) > b)
            p(i) = 0;
        else
            p(i) = middle;
        end
    end
    
end