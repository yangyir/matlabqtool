classdef BookHedgerArray < ArrayBase
    %
%BOOKHEDGERARRAY hedger��array
% -----------------------------
% �콭��20161225
    
    properties(Abstract = false)
        node;
    end
    
    properties(Abstract = false, Hidden = true)
        % ����ȷ��ָ�������ȷ��ʵ����
        % Ī�������ǳ��ִ�ʵ�������
        objID;
    end
    
    
    methods
        function set.node(self, node)
            if isa(node, 'BookHedger')
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
            % ��ʼִ��Hedge
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
            % ��ʼִ��Query
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