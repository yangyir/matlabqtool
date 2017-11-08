classdef CushionBase < IRGenerator
    methods
        function [obj] = CushionBase(share_percentage, rate)
            obj@IRGenerator;
            obj.set_management_rate(0);
            obj.set_management_percentage(share_percentage);            
            obj.check_and_fill_threshold(0, 1, rate);
            obj.discription = sprintf('������ȫ�����, �����˳��ʱ�����%f, �ֳɱ�����%f', share_percentage, rate);
        end
    end
end