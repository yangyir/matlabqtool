classdef CushionWaterLine < IRGenerator
    methods
        function [obj] = CushionWaterLine(share_percentage, waterline, rate)
            obj@IRGenerator;
            obj.set_management_rate(0);
            obj.set_management_percentage(share_percentage);
            obj.check_and_fill_threshold(waterline, 1, rate);
            obj.discription = sprintf('安全垫+水线, 管理人出资比例：%f, 水线：%f, 分成比例：%f', share_percentage, waterline, rate);
        end
    end
end