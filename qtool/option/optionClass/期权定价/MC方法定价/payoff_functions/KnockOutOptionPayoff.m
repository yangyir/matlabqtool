function [p] = KnockOutOptionPayoff(S)

    %% exotic payoff description
    % duration = 90 days.
    %
    % case 105% < ST/S0 < 115%:
    %     y = 0.35% + (St/S0 - 1)*2
    % case 85% < ST/S0 < 95%:
    %     y = 0.35% + (1 - ST/S0) * 2
    % else
    %     y = 0

    % 敲出条件;存续期内价格触碰到高限（115% * S0）或低限（85% * S0）
    % 输入量S为iterN * stepT矩阵。

    iterN = size(S,1);
    stepT = size(S,2);

    S0 = 1;
    high_limit = 1.15 * S0;
    limit_105 = 1.05 * S0;
    limit_95 = 0.95 * S0;
    low_limit = 0.85 * S0;
    ST = S(:, end);
    

    p  = ones(iterN, 1);
    knock_out_count = 0;
    total_count = iterN;
    % case knock out:
    for i = 1:iterN
        % check the knock out case
        if(max(S(i, :)) >= high_limit || min(S(i, :)) <= low_limit)
            p(i) = 0;
            knock_out_count = knock_out_count + 1;
        end
        if( 1 == p(i)) % not knocked out
            if( ST(i) > limit_105 && ST(i) < high_limit ) % case 1
                p(i) = 0.0035 + 2 * ( ST(i)/S0 - 1 );
            elseif ( ST(i) > low_limit && ST(i) < limit_95 )
                p(i) = 0.0035 + 2 * ( 1 - ST(i)/S0 );
            else
                p(i) = 0;
            end
        end
    end

    knock_out_rate = knock_out_count / total_count;
    disp(knock_out_rate);
end