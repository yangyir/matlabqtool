classdef BookHedgerArray < ArrayBase
    %
%BOOKHEDGERARRAY hedger的array
% -----------------------------
% 朱江，20161225
    
    properties(Abstract = false)
        node;
    end
    
    properties(Abstract = false, Hidden = true)
        % 用于确认指向的是正确的实例，
        % 莫名：总是出现串实例的情况
        objID;
    end
    
    
    methods
        function set.node(self, node)
            if isa(node, 'BookHedger')
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
        
        function [ret] = foreach_check_hedge(obj)
            L = obj.count;
            ret = false;
            for i = 1:L
                alert = obj.node(i).check_hedge_condition;
                if alert
                    ret = true;
                end
            end
        end
        
        function [ret] = foreachHedge(obj)
            % 开始执行Hedge
            L = length(obj.node);
            ret = false;
            for i = 1:L
                hedger = obj.node(i);
                result = hedger.place_hedge_entrusts;
                if result
                    ret = true;
                end
            end
        end   
        
        function [ret] = foreachQuery(obj)
            % 开始执行Query
            L = length(obj.node);
            ret = false;
            for i = 1:L
                hedger = obj.node(i);
                result = hedger.query_hedge_entrust;
                if result
                    ret = true;
                end
            end            
        end
    end
        
end