% ���ڵ��ڼ۸����(�㵽���յ�payoff)
function [ payoff ] = payoff_design_1_call(ST )
% ���ڵ��ڼ۸����(�㵽���յ�payoff)
    middle = 0.5;
    upper = 1;
    S0 = 1;
%     a = S0;
    a = 1.1 * S0;
    b = 1.2 * S0;
%     b = a;
    T = 30;

%     if(ST > b || double_equal(ST, b))
    if(ST >= b)
        payoff = upper;
    elseif(ST < a)
        payoff = 0;
    else
        payoff = middle;
    end
end