classdef FlatOnly < IRGenerator
    methods
        function [obj] = FlatOnly(rate)
            obj@IRGenerator;
            obj.check_and_fill_threshold(0, 1, rate);
            obj.description = 'Æ½²ã';
        end
    end
end