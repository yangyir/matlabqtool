classdef BookMonitorArray < ArrayBase
%BOOKMONITORARRAY monitor的array
% -----------------------------
% 朱江，20161220
    
    properties(Abstract = false)
        node;
%         asset_check_handler = @Entrust.is_same_asset;
    end
    
    properties(Abstract = false, Hidden = true)
        % 用于确认指向的是正确的实例，
        % 莫名：总是出现串实例的情况
        objID;
    end
    
    
    methods
        function set.node(self, node)
            if isa(node, 'BookMonitor')
                self.node = node;
            else
                warning('赋值失败：类型错误！');
            end            
        end
                
    end
    
    methods
        function new = copy(obj)
            % copy() is for deep copy case.
            new = feval(class(obj));
            % copy all non-hidden properties
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i});
            end
        end
        
        function [count] = count(obj)
            [~,count] = size(obj.node);
        end       
        
        function [] = foreachCheck(obj, S, vs, r)
            L = length(obj.node);
            for i = 1:L
                monitor = obj.node(i);
                monitor.update_env(S, vs, r);
                monitor.check_risks;
            end
        end        
    end
    
end

