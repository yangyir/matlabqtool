classdef CushionWaterLine < IRGenerator
    methods
        function [obj] = CushionWaterLine(share_percentage, waterline, rate)
            obj@IRGenerator;
            obj.set_management_rate(0);
            obj.set_management_percentage(share_percentage);
            obj.check_and_fill_threshold(waterline, 1, rate);
            obj.discription = sprintf('��ȫ��+ˮ��, �����˳��ʱ�����%f, ˮ�ߣ�%f, �ֳɱ�����%f', share_percentage, waterline, rate);
        end
    end
end