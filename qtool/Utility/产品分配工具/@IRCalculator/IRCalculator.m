%Ͷ�����������
% �м��ַ���
% �йܷ�
% �����
% �ֳ�
% �ֳɿ�����һϵ�нڵ㣬��ͬ�ڵ㲻ͬ�ķֳɱ�����
classdef IRCalculator < handle
    properties
        % �йܷ�
        custodyFeeRate = 0.003;
        % �����
        managementFeeRate = 0.01;
        % Ͷ�˳��ʱ���
        managerPercentage = 0;
        % ��ֵnode
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
            % ����������0~20% ֮�䣬�ֳ�10%
            % setThreshold(0, 0.2, 0.1);
            obj.polyThresholdMin = [obj.polyThresholdMin, barrier_min];
            obj.polyThresholdMax = [obj.polyThresholdMax, barrier_max];
            obj.polyReturnRate = [obj.polyReturnRate, rate];
        end
        
    end
    
    methods
        function [mgr, inv] = calculate_return(obj)
            % �����������Ϊ������
            % 1. ����ѣ��̶����������ʣ����޹���ѡ�
            mgr_fee = obj.managementFeeRate;
            % 2. �����ʽ�����, ����ʱ��ȫ�棬��Ǯʱ��������        
            mp_offset = obj.managerPercentage * (obj.managerPercentage - 1);
            mgr_inv_return_fun = @(x) (obj.managerPercentage * x + mp_offset).*(x < (-1)*obj.managerPercentage) + (x).*(x >= (-1)*obj.managerPercentage & x < 0) + (obj.managerPercentage * x).*(x >=0);            
            % 3. �ֳ�����
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
            % �������ۼ����棺
            mgr_total_return_fun = @(x) mgr_fee + mgr_inv_return_fun(x) + mgr_profit_share_fun(x);
%             obj.x = obj.x(obj.x >= (-1) * obj.managerPercentage)
            mgr = mgr_total_return_fun(obj.x);
            
            % Ͷ��������
            % �ֳɲ���
            inv_profit_return_fun = @(x) (x - mgr_profit_share_fun(x)).*(x >= 0);
            % ���𲿷�
            ip_offset = (-1) * mp_offset;
            inv_loss_return_fun = @(x) -mgr_fee + (invPercentage * x + ip_offset).*(x < (-1)*obj.managerPercentage);
            % Ͷ�����ۼ�����
            inv_total_return_fun = @(x) inv_profit_return_fun(x) + inv_loss_return_fun(x);
            inv = inv_total_return_fun(obj.x);
        end
        
    end
    
end