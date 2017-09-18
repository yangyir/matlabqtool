classdef OptionOneM2TK < M2TK
    %OptionOneM2TK, 管理OptionOne，提供Save Load 方法，提供init from qms方法。
    % 
    % cg, 20160420, 加入一些print函数
    
    properties
        fn@char = 'OptionOneM2TK.xlsx';
    end
    
    methods
        function [obj] = OptionOneM2TK(des)
            % 构造函数, des为矩阵描述
            % [obj] = OptionOneM2TK(des)
            obj = obj@M2TK(des) ;
%             obj.data = OptionOne;
            obj.datatype = 'OptionOne';
        end
        
%         function [obj] = load_from_excel(obj, fn)
%             % [obj] = load_from_excel(fn)
%             % 从Excel中载入OptionOneM2TK。
%             obj.fn = fn;
%             [~, desc, ~] = xlsfinfo(fn);
%             % 暂时hardcode，desc是所有sheet，暂定T为4个月份不变
%             % sheet1 为多余的默认页面，去掉。
%             % 每个OptionOne有4个页面来记录内容
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
%             % 对M2TK中的元素依次save，每个OptionOne都单独用一组sheet来记录。
%             % 各sheet通过t,k命名来区分归属。
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
            % 执行过程应该是，首先由交易所的期权信息文件来构造M2TK。
            % 再load_from_excel来加载仓位信息。
            nT = length(obj.yProps);
            nK = length(obj.xProps);
            try
                [num, txt, raw] = xlsread(filename, 'positions');
                [L, C] = size(raw);
                % 取得各属性所占名
                % optInfo
                % positionLong
                % positionShort
                % 每一列都是一个OptionOne
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
                    
                    % 查找对应的t,k位置，塞入data(t,k)
                    [success, t, k] = obj.find_opt_t_k(optinfo);
                    if(success)
                        obj.data(t,k) = opt;
                    end
                end

                % 构造xProps 和 yProps
                [nT, nK] = size(obj.data);
                for k = 1:nK
                    % 可能有无效期权数据
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
            % 该方法目的，是将Book中的Position数据载入至OptionOneM2TK
            
            success = false;
            % 覆盖的情况，首先清空现有数据。
            obj.clear_positions();            
            
            pan = book.positions.node;
            L = length(pan);
            for i = 1:L
                p = pan(i);
                [found, t, k] = obj.find_opt_t_k_by_code(p.instrumentCode);
                if(found)                    
                    optone = obj.data(t,k);
                    dst_pa = optone.positions;
                    % 对于OptionOne来说，一个品种上有一个PositionArray，以及PositionLong和PositionShort
                    dst_pa.try_merge_ifnot_push(p);
                    % 向positionLong和positionShort中做改变
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
                disp('book的持仓和现有OptionOne不匹配');
            end
        end

        function [] = clear_positions(obj)
            % 将所有持仓数据清空
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
        
        % 把qms中的Quotes指针赋给optionOne, 函数名不能达意
        % TODO：改名， link_to_qms_quotes,  point_to_qms_quotes
        function [] = attach_to_qms(obj, qms)
            switch obj.des2
                case 'call'
                    quotes_m2tk = qms.callQuotes_;
                case 'put'
                    quotes_m2tk = qms.putQuotes_;
            end
            
            % qms中的M2TK维度
            nT = length(quotes_m2tk.yProps);
            nK = length(quotes_m2tk.xProps);
            
            % 自身M2TK的维度
            T = length(obj.yProps);
            K = length(obj.xProps);
            
            if( ~(T == nT) || ~(K == nK))
                disp('QMS 和 OptionOne 维度不一致，请检查设置');
                return;
            end
            
            for t = 1:nT
                for k = 1:nK
                    % 取quote出来
                    quote = quotes_m2tk.data(t,k);
                    obj.data(t,k).quote = quote;
                end
            end
             
        end
        
        function [] = attach_to_counter(obj, counter)
            % qms中的M2TK维度
            nT = length(quotes_m2tk.yProps);
            nK = length(quotes_m2tk.xProps);
            for t = 1:nT
                for k = 1:nK
                    % 挂counter上去
                    obj.data(t,k).counter = counter;
                end
            end
        end
        
    end
    
    
    %% 输出的方法
    methods
        function print_positionLong(obj)
            % 输出形同：
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
            % 输出形同：
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
            
            %% 把OptInfo的M2TK 复制到OptionOneM2TK
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
            
            %% 生成OptionOne并归置
            call_ones.data = OptionOne;
            put_ones.data = OptionOne;
            
            nT = length(call_ones.yProps);
            nK = length(call_ones.xProps);
            
            for t = 1:nT
                for k = 1:nK
                    callOne = OptionOne;
                    % 填 optinfo
                    callOne.optinfo = m2c.data(t,k);                    
                    % positions, orderbook 等在OptionOne 的setter.optinfo里自动填

                    % 装入
                    call_ones.data(t,k) = callOne;

                    
                    putOne = OptionOne;
                    % 填 optinfo
                    putOne.optinfo = m2p.data(t,k);
                    % positions, orderbook 等在OptionOne 的setter.optinfo里自动填
               
                    % 装入
                    put_ones.data(t,k) = putOne;
                end
            end
        end
    end
end