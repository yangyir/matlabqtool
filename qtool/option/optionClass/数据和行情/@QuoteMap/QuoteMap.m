classdef QuoteMap < handle
    % QuoteMap 作为一种容器来维护（code, quote）键值对，通过code可以方便的查找到对应的Quote
    properties
        mp;
    end
    
    methods
        function [obj] = QuoteMap()
            obj.mp = containers.Map('KeyType', 'char', 'ValueType', 'any');
        end
    end
    
    methods
        function [obj] = add(obj, key, value)
            obj.mp(key) = value;
        end
        
        function [obj] = remove(obj, key)
            obj.mp.remove(key);
        end
        
        function [quote] = getQuote(obj, key)
            quote = obj.mp(key);
        end
        
        function [ bool ] = contains(obj, key)
            bool = obj.mp.isKey(key);
        end
    end
end