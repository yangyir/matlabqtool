% TermStructure is the Value(tau) relationship

classdef TermStructure < handle
    properties
        N_fit_exponent_ = 2;
        fit_args_ = [];
    end
    
    properties
        unique_val_ = [];
        x_value_ = [];
        fun_x_value_ = [];
    end
    
    methods
        [newobj] = getCopy(obj);
        function [obj] = load_data(obj, x_val, fun_x_val, unique)
            %function [obj] = load_data(obj, x_val, fun_x_val, unique)
            % unique to identify the termstructure;
            
            obj.unique_val_ = unique;
            obj.x_value_ = x_val;
            obj.fun_x_value_ = fun_x_val;
        end
        
        function [obj] = calibrate(obj)
            % function [obj] = calibrate(obj)
            obj.fit_args_ = polyfit(obj.x_value_, obj.fun_x_value_, obj.N_fit_exponent_);
        end
        
        function [data_val] = calculate(obj, tau)
            % function [data_val] = calculate(obj, tau)
            data_val = polyval(obj.fit_args_, tau);
        end
    end
end