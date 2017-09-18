classdef BookMonitorArray < ArrayBase
%BOOKMONITORARRAY monitor��array
% -----------------------------
% �콭��20161220
    
    properties(Abstract = false)
        node;
%         asset_check_handler = @Entrust.is_same_asset;
    end
    
    properties(Abstract = false, Hidden = true)
        % ����ȷ��ָ�������ȷ��ʵ����
        % Ī�������ǳ��ִ�ʵ�������
        objID;
    end
    
    
    methods
        function set.node(self, node)
            if isa(node, 'BookMonitor')
                self.node = node;
            else
                warning('��ֵʧ�ܣ����ʹ���');
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

