classdef EntrustArray < ArrayBase
%ENTRUSTARRAY entrust��array
% -----------------------------
% �̸գ�20160204
% cg, 161017, �����entrust��صĺ�����
%     query_optEntrusts_HSO32(obj, counter)
% cg, 161020, ����property��  objID�� ����ʶ��ͬʵ����debug��

    
    properties(Abstract = false)
        % ���ﲻ��д node@Entrust, ��Ϊ����ArrayBase����nodeû���κ�����
        % ���е�����ֻ����set������д
        % ͬʱ�������ʼ������ȷ���࣬���򣬺�����ֵ�����
        node = Entrust;
        asset_check_handler = @Entrust.is_same_asset;
    end
    
    properties(Abstract = false, Hidden = true)
        % ����ȷ��ָ�������ȷ��ʵ����
        % Ī�������ǳ��ִ�ʵ�������
        objID;
    end
    
    
    methods
        function set.node(self, node)
            if isa(node, 'Entrust')
                self.node = node;
            else
                warning('��ֵʧ�ܣ����ʹ���');
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
            % �����ʼ�ֲ�Ϊ�գ�����Entrust��¼����EntrustArray�С�
            
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
            
            % ����ѭ�������������
            % Entrusts ȫ����������Position����ȣ������Ϊtrue��
            % Entrust ����һ���֣�Position �����꣬���������Ԫ���Ƕ���ȣ������Ϊfalse��
            % Entrust ��Position û����ͬAsset��Entrustû�ߣ�Position���꣬�����Ϊfalse��
            if(probe_id > entrusts_num)
                isequal = true;
                return;
            else
                isequal = false;
                return;
            end
        end
        
        
        %% һЩ�������
        function [] = print_assetone_entrusts( pea )
            % ��ӡ��һ��Լ�Ĺҵ�/�ɽ����������������array���entrusts�Ƿ����ͬһ����Լ
            % ������в�ͬ��Լ���µ��������ǻ�ϵģ���������
%             ��ͬ��
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
                disp('û�йҵ�');
                return;
            end
            
            for i = 1:L
                e = pea.node(i);
                mat(i,:) = [e.direction, e.price, e.volume, 1];
            end
            
            
            % sort price
            [px, idx] = sort(mat(:,2), 'descend');
            matnew = mat(idx, :);
            
            
            % TODO: �ϲ�
            % 
            
            % ��ӡ, ��������������
            for i = 1:size(matnew, 1)
                if matnew(i, 1) == 1  % ��
                    fprintf('\t%0.4f\t%d\n', matnew(i,2), matnew(i,3));
                elseif matnew(i,1) == -1 %����
                    fprintf('%d\t%0.4f\t\n', -matnew(i,3), matnew(i,2));
                end
            end
            
        end
    end
    
    
    %% ��Entrust��صĹ��ܺ���
    methods
        function query_optEntrusts_HSO32(obj, counter)
            % ��һ��ѯһ��entrusts
            
            if ~exist( 'counter', 'var')
                warning('�����޷���ѯ�������ṩ��̨counter��');
                return;
            end
            
            L  = obj.latest;
            
            for i = 1:L
                e = obj.node(i);
                % TODO��Ӧ���ж�e�ı�����ͣ���Ʊ����Ȩ���ڻ���
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

