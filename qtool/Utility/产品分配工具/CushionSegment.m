classdef CushionSegment < IRGenerator
    methods
        function [obj] = CushionSegment(share_percentage)
            obj@IRGenerator;
            obj.set_management_rate(0);
            obj.set_management_percentage(share_percentage);    
            obj.discription = sprintf('安全垫+分段, 管理人出资比例：%f', share_percentage, waterline, rate);
        end
    end
end