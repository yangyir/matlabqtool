function [p] = VanillaOptionPayoff(S)
%% ��������1��
% ���� 268��
% ���ڻر���
% case ST >= 150% * S0:
% �ر�����Ϊ 20%
% case 110% * S0 < ST < 150% * S0
% �ر�����Ϊ [(ST/S0 - 1) - 10%] * 0.5
% case ST <= 110% * S0:
% �ر�Ϊ0

%% ��һ��
% S0 = 1
% ST <= 1.1: p = 0
% 1.1 < ST < 1.5: p = 2.5 * (ST - 1.1);
% ST >= 1.5 p = 1;

%% implementation��
    [iterN, stepT]  = size(S);
    
    ST = S(:, end);
    high_limit = 1.5 ;
    low_limit = 1.1 ;
    p  = ones(iterN, 1);
    factor = 1;
    low_count = 0;
    high_count = 0;
    total_count = iterN;
    for i = 1:iterN % loop rows
        %�ر�����ֻ��ST���
        if ST(i) <= low_limit
            p(i) = 0;
            low_count = low_count + 1;
        elseif low_limit < ST(i) && ST(i) < high_limit
            p(i) = 2.5 * (ST(i) - 1.1); 
        else
            p(i) = 1;
            high_count = high_count + 1;
        end
    end
    low_rate = low_count / total_count;
    high_rate = high_count / total_count;
    stringa = sprintf('low rate is %f .\n', low_rate);
    stringb = sprintf('high rate is %f .\n', high_rate);
    disp(stringa);
    disp(stringb);
end