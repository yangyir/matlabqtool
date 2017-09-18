% SmileSection 

classdef SmileSection < handle
    properties
        N_fit_exponent_ = 2;
        fit_args_ = [];
    end
    
    properties
        unique_val = 0;
        x_value_ = [];
        fun_x_value_ = [];
    end
    
    methods
        [newobj] = getCopy(obj);
        function [obj] = calibrate(obj)
            obj.fit_args_ = polyfit(obj.x_value_, obj.fun_x_value_, obj.N_fit_exponent_);
        end
        
        function [obj] = load_data(obj, x_val, fun_x_data, unique)
            obj.unique_val = unique;
            obj.x_value_ = x_val;
            obj.fun_x_value_ = fun_x_data;
        end
        
        function [val] = zero_val(obj)
            %function [val] = zero_val(obj)
            % 对于ATM的场景：Moneyness 为0；
            val = polyval(obj.fit_args_, 0);
        end
        
        function [val] = calculate(obj, arg)
            % function [val] = calculate(obj, arg)
            val = polyval(obj.fit_args_, arg);
        end
    end
end