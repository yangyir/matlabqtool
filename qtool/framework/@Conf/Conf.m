classdef Conf<handle
% 储存常用的配置变量

% 程刚，20131210；
    
    properties
        config;
    end
    
    %% constructor
    methods
        function obj = Conf(config)
            if ~exist('config', 'var')
                return;
            end
            
            obj.config = config;
        end
        
    end
    
    
    
    %%
    methods 
        [obj] = setRootPath(obj, rootPath);
        [obj] = recalcPaths(obj);
        addPaths(obj);
        
        
        [newconf, obj] = mergewith(obj, conf);
    end
    
    methods (Static = true)
        
        
        
    end
    
end

