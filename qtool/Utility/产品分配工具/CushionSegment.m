classdef CushionSegment < IRGenerator
    methods
        function [obj] = CushionSegment(share_percentage)
            obj@IRGenerator;
            obj.set_management_rate(0);
            obj.set_management_percentage(share_percentage);    
            obj.discription = sprintf('��ȫ��+�ֶ�, �����˳��ʱ�����%f', share_percentage, waterline, rate);
        end
    end
end