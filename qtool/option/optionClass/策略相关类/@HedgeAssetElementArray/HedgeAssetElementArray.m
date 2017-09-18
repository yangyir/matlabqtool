classdef HedgeAssetElementArray < ArrayBase
%HedgeAssetElementArray hedgeElement的array
% -----------------------------
% 朱江，20161226
    
    properties(Abstract = false)
        node;
    end
       
    methods
        function set.node(self, node)
            if isa(node, 'HedgeAssetElement')
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
        
        function [min_hedge_delta] = delta(obj)
            min_hedge_delta = 0;
            L = obj.count;
            for i = 1:L
                min_hedge_delta = min_hedge_delta + obj.node(i).base_delta;
            end
        end
        
        function [] = arrange_target_factor(obj, factor)
            L = obj.count;
            for i = 1:L
                obj.node(i).set_target_factor(factor);
            end
        end
        
        function [ret] = foreach_place(obj)  
            ret = true;
            L = obj.count;
            for i = 1:L
                result = obj.node(i).do_hedge_place_entrust;
                if ~result
                    disp('hedge asset place failed');
                    ret = false;
                end
            end
        end
        
        function [ret] = foreach_query(obj)
            ret = true;
            L = obj.count;
            for i = 1:L
                obj.node(i).do_hedge_update_entrust;
            end
        end
        
        function [ret] = foreach_check(obj)
            ret = true;
            L = obj.count;
            for i = 1:L
                hedge_finished = obj.node(i).do_hedge_check_target;
                if ~hedge_finished
                    ret = false;
                end
            end
        end
        
        function [found, index] = contains(obj, key)
            found = false;
            index = -1;
            L = obj.count;
            for i = 1:L
                ret = obj.node(i).is_same_asset(key);
                if ret
                    found = true;
                    index = i;
                    return;
                end
            end
        end
    end            
    
end

