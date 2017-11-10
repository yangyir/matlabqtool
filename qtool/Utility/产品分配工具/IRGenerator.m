classdef IRGenerator < IRCalculator
    properties
        description = '��������';
        mgr = 0;
        inv = 0;
    end
    methods
        function [] = calc(obj)
            [obj.mgr, obj.inv] = obj.calculate_return;
        end
        
        function [] = set_description(obj, description)
            obj.description = description;
        end
        
        function [hfig] = plotManagerReturn(obj)
            hfig = plot(obj.x, obj.mgr);
            legend('����������');
        end
        
        function [hfig] = plotInvestorReturn(obj)            
            hfig = plot(obj.x, obj.inv);
            legend('Ͷ��������');
        end
        
        function [hfig] = plotReturn(obj)
            % �ٶ������ʼ��ֵΪ100
            hfig = plot(obj.x, 100 * obj.mgr, obj.x, 100 * obj.inv, '--');
            desc_str = [obj.description, '��������'];
            title(desc_str);
            legend('����������', 'Ͷ��������');
        end
        
        function [hfig] = plotYield(obj)
            mgr_yield = (obj.mgr ./ obj.managerPercentage);
            inv_yield = (obj.inv ./ (1 - obj.managerPercentage));
            hfig = plot(obj.x, mgr_yield, obj.x, inv_yield, '--');
            desc_str = [obj.description, '����������'];
            title(desc_str);
            legend('������������', 'Ͷ����������');
        end
    end
end