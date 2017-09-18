classdef BinomialElementGenerator    
    methods (Static)
        function [p, q] = calc_probability(u, d, t, r)
            % function calc_up_probability ��������S������S*u�ĸ���p���µ���S*d�ĸ���q
            % ������p + q = 1
            % p * u + q * d = e^(r * deltaT)
            T = t/365; % �껯
            p = (exp(r*T) - d) / (u - d);
            q = 1 - p;
        end
    end
end