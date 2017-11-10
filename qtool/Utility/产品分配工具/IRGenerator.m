classdef IRGenerator < IRCalculator
    properties
        description = '无名规则';
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
            legend('管理人收益');
        end
        
        function [hfig] = plotInvestorReturn(obj)            
            hfig = plot(obj.x, obj.inv);
            legend('投资人收益');
        end
        
        function [hfig] = plotReturn(obj)
            % 假定基金初始净值为100
            hfig = plot(obj.x, 100 * obj.mgr, obj.x, 100 * obj.inv, '--');
            desc_str = [obj.description, '收益曲线'];
            title(desc_str);
            legend('管理人收益', '投资人收益');
        end
        
        function [hfig] = plotYield(obj)
            mgr_yield = (obj.mgr ./ obj.managerPercentage);
            inv_yield = (obj.inv ./ (1 - obj.managerPercentage));
            hfig = plot(obj.x, mgr_yield, obj.x, inv_yield, '--');
            desc_str = [obj.description, '收益率曲线'];
            title(desc_str);
            legend('管理人收益率', '投资人收益率');
        end
    end
end