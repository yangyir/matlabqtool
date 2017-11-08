classdef FlatWaterLine < IRGenerator
    methods
        function [obj] = FlatWaterLine(line, rate)
            %function [obj] = FlatWaterLine(line, rate)
            obj@IRGenerator;
            obj.check_and_fill_threshold(0, line, 0);
            obj.check_and_fill_threshold(line, 1, rate);
            obj.description = 'Æ½²ã+Ë®Ïß';
        end
    end
end