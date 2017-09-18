classdef BinomialElementGenerator    
    methods (Static)
        function [p, q] = calc_probability(u, d, t, r)
            % function calc_up_probability 计算上涨S上涨至S*u的概率p和下跌至S*d的概率q
            % 其中有p + q = 1
            % p * u + q * d = e^(r * deltaT)
            T = t/365; % 年化
            p = (exp(r*T) - d) / (u - d);
            q = 1 - p;
        end
    end
end