classdef CharKeyMapBase < handle
    % CharKeyMapBase ��Ϊһ��������ά����code, node_obj����ֵ�ԣ�ͨ��code���Է���Ĳ��ҵ���Ӧ��node
    % node �������������͵Ķ���
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