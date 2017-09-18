function [p] = payoff_gddt1_MC(S)
%%光大鼎泰1号MonteCarlo定价方法
    upper = 1;
    S0 = 1;
    a = 1.035 * S0;
    b = 1.185 * S0;
    T = 268;
    iterN = size(S,1);
    stepT = size(S,2);

    ST = S(:, end);

    p  = ones(iterN, 1);
    %     knock_out_count = 0;
    %     total_count = iterN;
    % case knock out:
    for i = 1:iterN
        if(ST(i) >= a && ST(i) < b)
            p(i) = 1/(b - a) * (ST(i) - a);
        else
            p(i) = 0;
        end
    end

end