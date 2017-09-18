classdef EntrustArray < ArrayBase
%ENTRUSTARRAY entrust的array
% -----------------------------
% 程刚，20160204
% cg, 161017, 加入跟entrust相关的函数：
%     query_optEntrusts_HSO32(obj, counter)
% cg, 161020, 加入property：  objID， 用于识别不同实例，debug用

    
    properties(Abstract = false)
        % 这里不能写 node@Entrust, 因为基类ArrayBase申明node没带任何限制
        % 所有的限制只能在set方法里写
        % 同时，必须初始化成正确的类，否则，后续赋值会出错
        node = Entrust;
        asset_check_handler = @Entrust.is_same_asset;
    end
    
    properties(Abstract = false, Hidden = true)
        % 用于确认指向的是正确的实例，
        % 莫名：总是出现串实例的情况
        objID;
    end
    
    
    methods
        function set.node(self, node)
            if isa(node, 'Entrust')
                self.node = node;
            else
                warning('赋值失败：类型错误！');
            end            
        end
        
%         function obj = EntrustArray()
%             obj.node = Entrust;
%         end
%         
        
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
        
        function [obj] = sort_by_code(obj)
            % sort_by_code() will sort the entrusts by lexicographical order
            % according their instrument code 
            % convert element code to fit sort argument
            % build in sort function accept {'code a' 'code b' 'code c' 'code d'}
            [~,idx] = sort({obj.node.instrumentCode});
            obj.node = obj.node(idx);            
        end
        
        function [obj] = merge_entrusts(obj)
            probe_id = 1;
            test_id = 1;
            [~,count] = size(obj.node);
            rmidxs = zeros(count, 1); % array keep removable index
            rmidx = 1;
            while(probe_id < count && test_id < count)
                probe = obj.node(probe_id);
                test_id = test_id + 1;
                next = obj.node(test_id);
                if(obj.asset_check_handler(probe, next))
                    %merge
                    probe.merge_position(next);
                    rmidxs(rmidx) = test_id;
                    rmidx = rmidx+1;
                else
                    % probe_id++
                    probe_id = test_id;
                    %test equal code;
                end
            end
            rmidxs = rmidxs(find(rmidxs));
            obj.removeByIndex(rmidxs);            
        end
    end
    
    methods 
        function [isequal] = is_equal_to_positions(obj, position_array)
            % 假设初始持仓为空，所有Entrust记录均在EntrustArray中。
            
            % make copy for further usage.
            temp_entrusts = obj.copy();
            temp_positions = position_array.copy();
            
            % sort by code
            temp_entrusts.sort_by_code();
            temp_positions.sort_by_code();
            
            % merge entrusts to make it unique
            temp_entrusts.merge_entrusts();
            
            
            [~, entrusts_num] = size(temp_entrusts.node);
            [~, positions_num] = size(temp_positions.node);
            probe_id = 1;
            test_id = 1;            
            while(probe_id <= entrusts_num && test_id <= positions_num)
                probe_position = temp_entrusts.node(probe_id).entrust_to_position();
                test_position = temp_positions.node(test_id);
                if( probe_position.is_same_asset(test_position))
                    if(~probe_position.is_equal_position(test_position))
                        isequal = false;
                        return;
                    end
                    % probe == test, so move to next pair
                    test_id = test_id + 1;
                    probe_id = probe_id + 1;
                else
                    % hold probe, move test to next position
                    test_id = test_id + 1;
                end
            end
            
            % 跳出循环有以下情况，
            % Entrusts 全部走完且与Position中相等，该情况为true。
            % Entrust 遍历一部分，Position 遍历完，且已走完的元素们都相等，该情况为false。
            % Entrust 与Position 没有相同Asset，Entrust没走，Position走完，该情况为false。
            if(probe_id > entrusts_num)
                isequal = true;
                return;
            else
                isequal = false;
                return;
            end
        end
        
        
        %% 一些输出函数
        function [] = print_assetone_entrusts( pea )
            % 打印单一合约的挂单/成交单的情况，不检验array里的entrusts是否基于同一个合约
            % 如果含有不同合约的下单，则结果是混合的，无意义了
%             形同：
%            -2	0.0196	
%            -4	0.0195	
%            -7	0.0194	
%                 0.0193	3
%                 0.0193	3
%                 0.0192	3
%                 0.0192	3
%                 0.0192	2

            L  = pea.latest;  % L = length(pe.node);
            if L == 0 
                disp('没有挂单');
                return;
            end
            
            for i = 1:L
                e = pea.node(i);
                mat(i,:) = [e.direction, e.price, e.volume, 1];
            end
            
            
            % sort price
            [px, idx] = sort(mat(:,2), 'descend');
            matnew = mat(idx, :);
            
            
            % TODO: 合并
            % 
            
            % 打印, 卖单在左，买单在右
            for i = 1:size(matnew, 1)
                if matnew(i, 1) == 1  % 买单
                    fprintf('\t%0.4f\t%d\n', matnew(i,2), matnew(i,3));
                elseif matnew(i,1) == -1 %卖单
                    fprintf('%d\t%0.4f\t\n', -matnew(i,3), matnew(i,2));
                end
            end
            
        end
    end
    
    
    %% 跟Entrust相关的功能函数
    methods
        function query_optEntrusts_HSO32(obj, counter)
            % 逐一查询一遍entrusts
            
            if ~exist( 'counter', 'var')
                warning('错误：无法查询，必须提供柜台counter！');
                return;
            end
            
            L  = obj.latest;
            
            for i = 1:L
                e = obj.node(i);
                % TODO：应该判断e的标的类型（股票、期权、期货）
                ems.HSO32_query_optEntrust_once_and_fill_dealInfo(e, counter);
            end
        end
        
        
%         function 
        
    end
    
    methods(Static = true)
        [] = demo()
        [] = test_merge()
        [] = test_verify_position()
    end
        
    
end

