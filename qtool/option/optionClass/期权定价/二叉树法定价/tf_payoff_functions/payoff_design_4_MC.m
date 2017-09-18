% 基于到期价格计算(算到期日的payoff)
function [ p ] = payoff_design_4_MC(S)
% 基于到期价格计算(算到期日的payoff)
    iterN = size(S,1);
    stepT = size(S,2);

    ST = S(:, end);

    upper = 1;
    S0 = 1;
    a = 0.95 * S0;
    b = 1.05 * S0;
    T = 20;

    p  = ones(iterN, 1);
%     knock_out_count = 0;
%     total_count = iterN;
    % case knock out:
    for i = 1:iterN
        % check the knock out case
        if(max(S(i, :)) > b || min(S(i, :)) < a)
            p(i) = 0;
%             knock_out_count = knock_out_count + 1;
        end
        if( 1 == p(i)) % not knocked out
            if( ST(i) >= a && ST(i) <= b ) % case 1
                p(i) = upper;
            else
                p(i) = 0;
            end
        end
    end

%     knock_out_rate = knock_out_count / total_count;
%     disp(knock_out_rate);    
end