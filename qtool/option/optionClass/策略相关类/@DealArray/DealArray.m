classdef DealArray < ArrayBase
%TRADETARRAY deal的array
% -----------------------------
% 朱江， 20170608.
    
    properties(Abstract = false)
        % 这里不能写 node@Trades, 因为基类ArrayBase申明node没带任何限制
        % 所有的限制只能在set方法里写
        % 同时，必须初始化成正确的类，否则，后续赋值会出错
        node = Deal;        
    end
    
    properties
        % 辅助统计属性
        % 品种： instrument
        instruments_;
        % 合约： contracts
        contracts_;
    end
        
    methods
        function set.node(self, node)
            if isa(node, 'Deal')
                self.node = node;
            else
                warning('赋值失败：类型错误！');
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
        % 从Excel载入DealArray
        [dealarray] = load_deals_from_excel(xls);
    end
end

