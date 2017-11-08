%投资收益计算器
% 有几种费用
% 托管费
% 管理费
% 分成
% 分成可能有一系列节点，不同节点不同的分成比例。
classdef IRCalculator < handle
    properties
        % 托管费
        custodyFeeRate = 0.003;
        % 管理费
        managementFeeRate = 0.01;
        % 投顾出资比例
        managerPercentage = 0;
        % 阈值node
        polyThresholdMin = -1;
        polyThresholdMax = -1;
        polyReturnRate = 0;
        % src
        x = -0.05:0.01:0.5; 
    end
    methods
        function [] = set_management_rate(obj, mgr_rate)
            %function [] = set_management_rate(obj, mgr_rate)
            obj.managementFeeRate = mgr_rate;
        end
        
        function [] = set_custody_rate(obj, custoday_rate)
            %function [] = set_custody_rate(obj, custoday_rate)
            obj.custodayRate = custoday_rate;
        end
        
        function [] = set_management_percentage(obj, percent)
            %function [] = set_management_percentage(obj, percent)
            obj.managerPercentage = percent;
        end
        
        function [] = set_x_axes_range(obj, start, stop)
            %function [] = set_x_axes_range(obj, start, stop)
            obj.x = start:0.01:stop;
        end
        
        function [] = check_and_fill_threshold(obj, barrier_min, barrier_max, rate)
            %function [] = check_and_fill_threshold(obj, barrier_min, barrier_max, rate)
            current_max = obj.polyThresholdMax(end);
            if current_max < barrier_min
                obj.set_threshold(current_max, barrier_min, 0);
            end
            obj.set_threshold(barrier_min, barrier_max, rate);
        end
    end
    
    methods (Access = private)
        function [] = set_threshold(obj, barrier_min, barrier_max, rate)
            %function [] = setThreshold(obj, barrier_min, barrier_max, rate)
            % 例：收益在0~20% 之间，分成10%
            % setThreshold(0, 0.2, 0.1);
            obj.polyThresholdMin = [obj.polyThresholdMin, barrier_min];
            obj.polyThresholdMax = [obj.polyThresholdMax, barrier_max];
            obj.polyReturnRate = [obj.polyReturnRate, rate];
        end
        
    end
    
    methods
        function [mgr, inv] = calculate_return(obj)
            % 管理人收益分为三部分
            % 1. 管理费（固定），若出资，则无管理费。
            mgr_fee = obj.managementFeeRate;
            % 2. 自有资金收益, 亏损时安全垫，挣钱时按比例。        
            mp_offset = obj.managerPercentage * (obj.managerPercentage - 1);
            mgr_inv_return_fun = @(x) (obj.managerPercentage * x + mp_offset).*(x < (-1)*obj.managerPercentage) + (x).*(x >= (-1)*obj.managerPercentage & x < 0) + (obj.managerPercentage * x).*(x >=0);            
            % 3. 分成收益
            invPercentage = 1 - obj.managerPercentage;
            mgr_profit_share_fun_str = sprintf('mgr_profit_share_fun = @(x) %f * (', invPercentage);
            L = length(obj.polyThresholdMin);
            for i = 1:L
                node_str = sprintf('%f * min(max((x - %f), 0), %f - %f)', obj.polyReturnRate(i), obj.polyThresholdMin(i), obj.polyThresholdMax(i), obj.polyThresholdMin(i));
                mgr_profit_share_fun_str = strcat(mgr_profit_share_fun_str, node_str);
                if i < L
                    mgr_profit_share_fun_str = strcat(mgr_profit_share_fun_str, ' + ');
                end
            end
            mgr_profit_share_fun_str = strcat(mgr_profit_share_fun_str, ')');
            eval(mgr_profit_share_fun_str);
            % 管理人累计收益：
            mgr_total_return_fun = @(x) mgr_fee + mgr_inv_return_fun(x) + mgr_profit_share_fun(x);
%             obj.x = obj.x(obj.x >= (-1) * obj.managerPercentage)
            mgr = mgr_total_return_fun(obj.x);
            
            % 投资人收益
            % 分成部分
            inv_profit_return_fun = @(x) (x - mgr_profit_share_fun(x)).*(x >= 0);
            % 亏损部分
            ip_offset = (-1) * mp_offset;
            inv_loss_return_fun = @(x) -mgr_fee + (invPercentage * x + ip_offset).*(x < (-1)*obj.managerPercentage);
            % 投资人累计收益
            inv_total_return_fun = @(x) inv_profit_return_fun(x) + inv_loss_return_fun(x);
            inv = inv_total_return_fun(obj.x);
        end
        
    end
    
end