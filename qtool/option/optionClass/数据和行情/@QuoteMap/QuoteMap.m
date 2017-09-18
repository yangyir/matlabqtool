classdef QuoteMap < handle
    % QuoteMap ��Ϊһ��������ά����code, quote����ֵ�ԣ�ͨ��code���Է���Ĳ��ҵ���Ӧ��Quote
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