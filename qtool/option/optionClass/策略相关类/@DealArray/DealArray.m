classdef DealArray < ArrayBase
%TRADETARRAY deal��array
% -----------------------------
% �콭�� 20170608.
    
    properties(Abstract = false)
        % ���ﲻ��д node@Trades, ��Ϊ����ArrayBase����nodeû���κ�����
        % ���е�����ֻ����set������д
        % ͬʱ�������ʼ������ȷ���࣬���򣬺�����ֵ�����
        node = Deal;        
    end
    
    properties
        % ����ͳ������
        % Ʒ�֣� instrument
        instruments_;
        % ��Լ�� contracts
        contracts_;
    end
        
    methods
        function set.node(self, node)
            if isa(node, 'Deal')
                self.node = node;
            else
                warning('��ֵʧ�ܣ����ʹ���');
            end            
        end                
    end
    
    methods
        function new = getCopy(obj)
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
        
        function [obj] = parse_deals(obj)
            if obj.isempty
                return;
            end
            
            obj.instruments_ = unique({obj.node(:).instrument_});
            obj.contracts_ = unique({obj.node(:).name_});            
        end
        
        function [deal_array] = split_by_instrument(obj, instrument)
            instruments = {obj.node(:).instrument_};
            idx = find(strcmp(instruments, instrument));
            deal_array = DealArray;
            for i = 1:length(idx)
                deal_array.push(obj.node(idx(i)));
            end
        end
        
        function [deal_array] = split_by_contract(obj, contract)
            contracts = {obj.node(:).name_};
            idx = find(strcmp(contracts, contract));
            deal_array = DealArray;
            for i = 1:length(idx)
                deal_array.push(obj.node(idx(i)));
            end
        end
        
        function [deal_array] = split_by_code(obj, contract)
            contracts = {obj.node(:).code_};
            idx = find(strcmp(contracts, contract));
            deal_array = DealArray;
            for i = 1:length(idx)
                deal_array.push(obj.node(idx(i)));
            end
        end
        
    end
    
    methods (Static = true)
        % ��Excel����DealArray
        [dealarray] = load_deals_from_excel(xls);
    end
end

