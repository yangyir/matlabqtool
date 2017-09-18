classdef OptionOneM2TK < M2TK
    %OptionOneM2TK, ����OptionOne���ṩSave Load �������ṩinit from qms������
    % 
    % cg, 20160420, ����һЩprint����
    
    properties
        fn@char = 'OptionOneM2TK.xlsx';
    end
    
    methods
        function [obj] = OptionOneM2TK(des)
            % ���캯��, desΪ��������
            % [obj] = OptionOneM2TK(des)
            obj = obj@M2TK(des) ;
%             obj.data = OptionOne;
            obj.datatype = 'OptionOne';
        end
        
%         function [obj] = load_from_excel(obj, fn)
%             % [obj] = load_from_excel(fn)
%             % ��Excel������OptionOneM2TK��
%             obj.fn = fn;
%             [~, desc, ~] = xlsfinfo(fn);
%             % ��ʱhardcode��desc������sheet���ݶ�TΪ4���·ݲ���
%             % sheet1 Ϊ�����Ĭ��ҳ�棬ȥ����
%             % ÿ��OptionOne��4��ҳ������¼����
%             nT = 4;
%             nK = (length(desc) - 1) / nT / 4;
% %             nT = length(obj.yProps);
% %             nK = length(obj.xProps);
%             for t = 1:nT
%                 for k = 1:nK
%                     obj.data(t,k) = OptionOne;
%                     obj.data(t,k).fromExcel(obj.fn, t,k);
%                 end
%             end            
%         end
        
%         function [] = save_to_excel(obj, fn)
%             %[] = save_to_excel(obj, fn)
%             % ��M2TK�е�Ԫ������save��ÿ��OptionOne��������һ��sheet����¼��
%             % ��sheetͨ��t,k���������ֹ�����
%             obj.fn = fn;
%             nT = length(obj.yProps);
%             nK = length(obj.xProps);
%             for t = 1:nT
%                 for k = 1:nK
%                     obj.data(t,k).toExcel(obj.fn, t,k);
%                 end
%             end
%         end
        
        function [table] = toTable(obj)
            
            [nT, nK] = size(obj.data);
            temp = obj.data(1,1);
            %title = {'t', 'k'};
            title_tk = temp.to_excel_title();
%             title = [title, title_tk];
            title = title_tk;
            table(1, :) = title;
            row_pos = 1;
            for t = 1:nT
                for k = 1:nK                    
                    optone = obj.data(t,k);
                    if(optone.is_optone_valid)
                        row_pos = row_pos + 1;
                        value = obj.data(t,k).to_excel_value();
                        %                     value_tk = {t, k};
                        %                     value = [value_tk, value];
                        table(row_pos, :) = value;
                    end
%                     [s, msg] = xlsappend(fn, value, 'positions');
                end
            end
        end
        
        function [obj] = save_to_excel(obj, fn)
            obj.fn = fn;
            % clear target sheet.
            xlsclear(fn);
            table = obj.toTable();
            xlswrite(fn, table, 'positions');
        end
        
        function [obj] = load_from_excel(obj, filename)
            % ִ�й���Ӧ���ǣ������ɽ���������Ȩ��Ϣ�ļ�������M2TK��
            % ��load_from_excel�����ز�λ��Ϣ��
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            try
                [num, txt, raw] = xlsread(filename, 'positions');
                [L, C] = size(raw);
                % ȡ�ø�������ռ��
                % optInfo
                % positionLong
                % positionShort
                % ÿһ�ж���һ��OptionOne
                for i = 2:L
                    opt = OptionOne;
                    
                    optinfo = OptInfo;
                    for j = 1:11 % option info
                        fd = raw{1, j};
                        optinfo.(fd) = raw{i, j};
                    end
                    opt.optinfo  = optinfo;
                    
                    positionLong = Position;
                    for j = 12:26  % position Long
                        fd = raw{1, j};
                        positionLong.(fd) = raw{i, j};
                    end
                    opt.positionLong = positionLong;
                    
                    positionShort = Position;
                    for j = 27:41  % position Short
                        fd = raw{1, j};
                        positionShort.(fd) = raw{i, j};                        
                    end
                    opt.positionShort = positionShort;
                    
                    % ���Ҷ�Ӧ��t,kλ�ã�����data(t,k)
                    [success, t, k] = obj.find_opt_t_k(optinfo);
                    if(success)
                        obj.data(t,k) = opt;
                    end
                end

                % ����xProps �� yProps
                [nT, nK] = size(obj.data);
                for k = 1:nK
                    % ��������Ч��Ȩ����
                    for t = 1:nT
                        info = obj.data(t,k).optinfo;
                        if info.is_valid_opt
                            K_props(k) = info.K;
                            break;
                        end
                    end
                end
                
                for t = 1:nT
                    for k = 1:nK
                        info = obj.data(t,k).optinfo;
                        if info.is_valid_opt
                            T_props(t) = {datestr(info.T)};
                            break;
                        end
                    end
                end
                
                obj.xProps = K_props;
                obj.yProps = T_props';                
                
            catch e
                disp(e);
            end
            
        end
        
        function [success] = load_positions_from_book(obj, book)
            % function [success] = load_book_positions( book)
            % �÷���Ŀ�ģ��ǽ�Book�е�Position����������OptionOneM2TK
            
            success = false;
            % ���ǵ��������������������ݡ�
            obj.clear_positions();            
            
            pan = book.positions.node;
            L = length(pan);
            for i = 1:L
                p = pan(i);
                [found, t, k] = obj.find_opt_t_k_by_code(p.instrumentCode);
                if(found)                    
                    optone = obj.data(t,k);
                    dst_pa = optone.positions;
                    % ����OptionOne��˵��һ��Ʒ������һ��PositionArray���Լ�PositionLong��PositionShort
                    dst_pa.try_merge_ifnot_push(p);
                    % ��positionLong��positionShort�����ı�
                    if p.longShortFlag == 1
                        optone.positionLong.mergePosition( p );
                    elseif p.longShortFlag == -1
                        optone.positionShort.mergePosition( p );
                    end
                    success = true;
                    disp(['t: ', num2str(t), ' k: ', num2str(k)]);
                    optone.positionLong.println;
                    optone.positionShort.println;
                    
%                     dst_pa.print;
                end
            end
            
            if(~success)
                disp('book�ĳֲֺ�����OptionOne��ƥ��');
            end
        end

        function [] = clear_positions(obj)
            % �����гֲ��������
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            for t = 1:nT
                for k = 1:nK
                    obj.data(t,k).positions.clear();
                end
            end
        end
        
        function [success, T, K] = find_opt_t_k(obj, optinfo)
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            success = false;
            T = 0;
            K = 0;
            for t = 1:nT
                for k = 1:nK
                    temp = obj.data(t,k);
                    if(strcmp(temp.optinfo.code, optinfo.code))
                        success = true;
                        T = t;
                        K = k;
                        return;
                    end
                end
            end
            
        end
        
        function [success, T, K] = find_opt_t_k_by_code(obj, code)
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            success = false;
            T = 0;
            K = 0;
            for t = 1:nT
                for k = 1:nK
                    temp = obj.data(t,k);
                    if(strcmp(temp.optinfo.code, code))
                        success = true;
                        T = t;
                        K = k;
                        return;
                    end
                end
            end
            
        end
        
        % ��qms�е�Quotesָ�븳��optionOne, ���������ܴ���
        % TODO�������� link_to_qms_quotes,  point_to_qms_quotes
        function [] = attach_to_qms(obj, qms)
            switch obj.des2
                case 'call'
                    quotes_m2tk = qms.callQuotes_;
                case 'put'
                    quotes_m2tk = qms.putQuotes_;
            end
            
            % qms�е�M2TKά��
            nT = length(quotes_m2tk.yProps);
            nK = length(quotes_m2tk.xProps);
            
            % ����M2TK��ά��
            T = length(obj.yProps);
            K = length(obj.xProps);
            
            if( ~(T == nT) || ~(K == nK))
                disp('QMS �� OptionOne ά�Ȳ�һ�£���������');
                return;
            end
            
            for t = 1:nT
                for k = 1:nK
                    % ȡquote����
                    quote = quotes_m2tk.data(t,k);
                    obj.data(t,k).quote = quote;
                end
            end
             
        end
        
        function [] = attach_to_counter(obj, counter)
            % qms�е�M2TKά��
            nT = length(quotes_m2tk.yProps);
            nK = length(quotes_m2tk.xProps);
            for t = 1:nT
                for k = 1:nK
                    % ��counter��ȥ
                    obj.data(t,k).counter = counter;
                end
            end
        end
        
    end
    
    
    %% ����ķ���
    methods
        function print_positionLong(obj)
            % �����ͬ��
% call, positionLong:
% 	1.80	1.85	1.90	1.95	2.00	2.05	2.10	2.15	2.20	2.25	2.30	2.35	2.40	2.45	2.50	2.55	2.60	2.65
% T1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
% T2	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
% T3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
% T4	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
            
            
            fprintf('%s, positionLong:\n', obj.des2);
            for iK = 1:18
                fprintf('\t%0.2f', obj.xProps(iK));
            end
            fprintf('\n');
            
           for iT = 1:4
               fprintf('T%d\t', iT);
               for iK = 1:18
                  fprintf('%d\t', obj.data(iT, iK).positionLong.volume);
                   
               end
               fprintf('\n');
           end
        end
        
        function print_positionShort(obj)
            % �����ͬ��
% call, positionShort:
% 	1.80	1.85	1.90	1.95	2.00	2.05	2.10	2.15	2.20	2.25	2.30	2.35	2.40	2.45	2.50	2.55	2.60	2.65
% T1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
% T2	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
% T3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
% T4	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	
       
            
            fprintf('%s, positionShort:\n', obj.des2);
             for iK = 1:18
                fprintf('\t%0.2f', obj.xProps(iK));
            end
            fprintf('\n');
            
           for iT = 1:4
               fprintf('T%d\t', iT);
               for iK = 1:18
                  fprintf('%d\t', obj.data(iT, iK).positionShort.volume);
                   
               end
               fprintf('\n');
           end
           
        end
        
        
        
        
        
    end
    
    
    methods (Static = true)
        function [call_ones, put_ones] = GetInstance()
            [~, m2c, m2p] = OptInfo.init_from_sse_excel;
            
            %% ��OptInfo��M2TK ���Ƶ�OptionOneM2TK
            flds = fields(m2c);
            call_ones = OptionOneM2TK('call');
            put_ones = OptionOneM2TK('put');
            L = length(flds);
            for i = 1:L
                try
                    call_ones.(flds{i}) = m2c.(flds{i});
                    put_ones.(flds{i}) = m2p.(flds{i});
                catch e
                end
            end
            
            %% ����OptionOne������
            call_ones.data = OptionOne;
            put_ones.data = OptionOne;
            
            nT = length(call_ones.yProps);
            nK = length(call_ones.xProps);
            
            for t = 1:nT
                for k = 1:nK
                    callOne = OptionOne;
                    % �� optinfo
                    callOne.optinfo = m2c.data(t,k);                    
                    % positions, orderbook ����OptionOne ��setter.optinfo���Զ���

                    % װ��
                    call_ones.data(t,k) = callOne;

                    
                    putOne = OptionOne;
                    % �� optinfo
                    putOne.optinfo = m2p.data(t,k);
                    % positions, orderbook ����OptionOne ��setter.optinfo���Զ���
               
                    % װ��
                    put_ones.data(t,k) = putOne;
                end
            end
        end
    end
end