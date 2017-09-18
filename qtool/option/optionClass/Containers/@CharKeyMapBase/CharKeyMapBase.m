classdef CharKeyMapBase < handle
    % CharKeyMapBase 作为一种容器来维护（code, node_obj）键值对，通过code可以方便的查找到对应的node
    % node 可以是任意类型的对象。
    properties
        mp;
    end
    
    methods
        function [obj] = CharKeyMapBase()
            obj.mp = containers.Map('KeyType', 'char', 'ValueType', 'any');
        end
    end
    
    methods
        function [obj] = add(obj, key, node)
            obj.mp(key) = node;
        end
        
        function [obj] = remove(obj, key)
            obj.mp.remove(key);
        end
        
        function [node] = get_node(obj, key)
            node = obj.mp(key);
        end
        
        function [ bool ] = contains(obj, key)
            bool = obj.mp.isKey(key);
        end
    end
end