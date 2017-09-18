classdef testClass
    properties
        TorF;
    end
    
    methods
        function obj=testClass()
        end
        
        function obj = nArg(obj,varargin)
            if nargin ==0
                obj.TorF = 1;
            else 
                obj.TorF = 0;
            end
            
            
        end
        
            
        
    
    
    end
    



end
