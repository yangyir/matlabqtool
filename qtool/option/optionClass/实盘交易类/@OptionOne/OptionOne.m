classdef OptionOne < AssetOne
    %%
    % -----------------------------
    % cg, 161017，修改了set.quote， set.optinfo， 加入orderbook相关
    
    
    properties
        optinfo@OptInfo;
        pricer@OptPricer;
        quote@QuoteOpt;
        
      

    end
    
    

    %% setters & getters
    methods
        function set.quote( obj, q )
            % disp('挂上quote, 同时设置positionLong，positionShort');
            L = length(obj.positions.node);
            pos = obj.positions.node(1);
            if( L == 1 && strcmp(pos.instrumentCode, '00000000'))
                pos.instrumentCode = q.code;
                pos.instrumentName = q.optName;
            end
            
            pos = obj.positionLong;
            pos.instrumentCode = q.code;
            pos.instrumentName = q.optName;
            
            pos = obj.positionShort;
            pos.instrumentCode = q.code;
            pos.instrumentName = q.optName;
            obj.quote = q;
            
            
            % 触发orderbook的更新
            obj.askOrderBook.code = q.code;
            obj.bidOrderBook.code = q.code;
            obj.askOrderBook.name = q.optName;
            obj.bidOrderBook.name = q.optName;
        end
            
        function set.optinfo(obj, opt)
            % disp('挂上optionf， 同时设置positionLong, positionShort');
            L = length(obj.positions.node);
            pos = obj.positions.node(1);
            if( L == 1 && strcmp(pos.instrumentCode, '00000000'))
                pos.instrumentCode = opt.code;
                pos.instrumentName = opt.optName;
            end
            
            obj.positionLong.instrumentCode = opt.code;
            obj.positionLong.instrumentName = opt.optName;
            
            obj.positionShort.instrumentCode = opt.code;
            obj.positionShort.instrumentName = opt.optName;
            
            obj.optinfo = opt;
            
            % 触发orderbook的更新
            obj.askOrderBook.code = opt.code;
            obj.bidOrderBook.code = opt.code;
            
            obj.askOrderBook.name = opt.optName;
            obj.bidOrderBook.name = opt.optName;
            
            obj.askOrderBook.iT = opt.iT;
            obj.bidOrderBook.iT = opt.iT;            
            
            obj.askOrderBook.iK = opt.iK;
            obj.bidOrderBook.iK = opt.iK;
        end

    end

    %% 各种下单函数
    methods
       
        % 下单，最宽泛的下单
        [e] = place_entrust_opt(obj, direc, volume, offset, px )
            
            
        % 下单，智能一些的下单方式
        
        % 可以自动判断开平仓（先看仓位）
        [e] = place_entrust_autoOffset(obj, direc, volume, px);

        
        % 可以调节价格方式——对价oppo，限价持平atpar，last价，mid价
        [e] = place_entrust_autoPx( obj, direc, volume, offset, pxType);   
        [e] = place_entrust_autoOffset_autoPx( obj, direc, volume, pxType);
        
        
        % 抢盘口n跳
        [e] = place_entrust_better_nTicks(obj, direc, volume, nTick, offset);
        
        
        % 下单可以设置价格让步的百分比
        % [e] = place_entrust_better_nPct(obj, direc, volume, offset, nPct)
        % nPct 可取（0,100%）以外
        % ask 到 bid 作为100%， 即
        %　买: bid 0%, ...,  ask 100%, ...
        %  卖：ask 0%, ...,  bid 100%, ...
        [e] = place_entrust_better_nPct(obj, direc, volume,  nPct, offset)
    
        
    end
    
    
    %% 各种撤单函数
    methods
        % 撤掉给定的特定单e
        function [] = cancel_entrust_opt(obj, e)
            ctr = obj.counter;
            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
            fprintf('【撤单】');
            e.println;
        end
        
        % 撤掉全部的单, 紧急情况用
        function [] = cancel_entrust_all(obj)
            % 撤掉全部的单, 紧急情况用

             ctr = obj.counter;
             ea  = obj.pendingEntrusts;
             for i = 1:ea.latest
                 e = ea.node(i);
                 ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
             end
        end
        
        
        % 撤掉某个价位上所有的单， buysellFlag = 'buy'. 'sell' 或 'both'
        function [] = cancel_entrusts_atPx( obj, px, buysellFlag )
            
            if ~exist('buysellFlag', 'var') 
                buysellFlag = 'both';
            end

            ctr = obj.counter;
            ea  = obj.pendingEntrusts;
            
            % 把switch套在外面，执行快
            switch buysellFlag
                case { 'both' }                    
                    for i = 1:ea.latest
                        e = ea.node(i);
                        if abs( e.price - px ) < 1e-12
                            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                        end
                    end
                    
                case { 'buy'}
                    for i = 1:ea.latest
                        e = ea.node(i);
                        if abs( e.price - px ) < 1e-12 && e.direction == 1
                            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                        end
                    end
                    
                case {'sell'}
                    for i = 1:ea.latest
                        e = ea.node(i);
                        if abs( e.price - px ) < 1e-12 && e.direction == -1
                            ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                        end
                    end
            end
            
        end
        
        % 撤掉5档以外的挂单
        function [] = cancel_entrusts_outof_nLevel( obj, nLevel )
            if ~exist('nLevel', 'var')
                nLevel = 5;
            end
            
            ctr = obj.counter;
            ea  = obj.pendingEntrusts;
            quote = obj.quote;
            quote.fillQuote;
            
            % 代码虽傻，运行最快
            if nLevel == 1
                ask_bound = quote.askP1;
                bid_bound = quote.bidP1;
            elseif nLevel == 2
                ask_bound = quote.askP2;
                bid_bound = quote.bidP2;
            elseif nLevel == 3
                ask_bound = quote.askP3;
                bid_bound = quote.bidP3;
            elseif nLevel == 4
                ask_bound = quote.askP4;
                bid_bound = quote.bidP4;
            else
                ask_bound = quote.askP5;
                bid_bound = quote.bidP5;
            end
            
            % 代码好看，运行慢，且容错处理复杂
%             fld_a = [ 'askP' num2str(nLevel) ];
%             fld_b = [ 'bidP' num2str(nLevel) ];
%             ask_bound = quote.(fld_a);
%             bid_bound = quote.(fld_b);
            
            % 逐一检验，符合条件就撤单
            for i = 1:ea.latest
                e = ea.node(i);
                if e.price < bid_bound || e.price > ask_bound
                    ems.cancel_optEntrust_and_fill_cancelNo(e, ctr);
                end
            end
             
        end
        
        
        function cancel_
            
        end
    end
    
    %% 有效性判断
    methods
        function [valid] = is_optone_valid(obj)
            valid = obj.optinfo.is_valid_opt();
            return;
        end
    end
    %% 输入输出函数
    methods
        function [] = toExcel(obj, filename, t, k)
            if(~exist('t', 'var') || ~exist('k', 'var'))
                appendix = '';
            else
                appendix = [num2str(t), '_', num2str(k)];
            end
            %% 默认xlsx类型
            className = class(obj);
            if ~exist('filename', 'var')
                disp('没有指定输出文件');
                return;
            end

            if isnan(filename)
                filename = [ 'my_' className '.xlsx'];
            elseif isempty(filename)
                filename = [ 'my_' className '.xlsx'];
            else
                po = strfind(filename, '.xls');
                if isempty(po)
                    % 添加扩展名
                    filename = [filename '.xlsx'];
                else
                    po = po(end);
                    ext = filename(po:end);
                    if ~strcmp(ext, '.xls') ||  ~strcmp(ext, '.xlsx') ...
                            || ~strcmp(ext, '.xlsm') || ~strcmp(ext, '.xlsb')
                        % 改变扩展名
                        filename = [filename(1:po-1) '.xlsx'];
                    end
                end
            end    
            
            %% 要放入optionOne自己的信息optinfo
            
            flds    = properties( obj.optinfo );
            F       = length(flds);
            table   = cell(F, 2);

            % 第1列写标题,  第2列写数据
            for row = 1:F
                f = flds{row};
                table{row, 1} = f;
                table{row, 2} = obj.optinfo.(f);
            end
            
            xlswrite(filename, table, ['OptionOneInfo',appendix]);                        
            toExcel@AssetOne(obj, filename, appendix);
        end
        
        function [value_row] = to_excel_value(obj)
            % row 有三部分组成，1.option info. 2. positionLong, 3. positionShort
            info_value = obj.optinfo.to_excel_value();
            long_pos_value = obj.positionLong.to_excel_value();
            short_pos_value = obj.positionShort.to_excel_value();
            value_row = [info_value, long_pos_value, short_pos_value];
        end
        
        function [title] = to_excel_title(obj)
            % title 分三部分， 1. option info. 2. positionLong 3. positionShort
            info_title = obj.optinfo.to_excel_title();
            long_pos_title = obj.positionLong.to_excel_title();
            short_pos_title = obj.positionShort.to_excel_title();
            title = [info_title, long_pos_title, short_pos_title];
        end
        
        function fromExcel(obj, filename, t, k)
            if(~exist('t', 'var') || ~exist('k', 'var'))
                appendix = '';
            else
                appendix = [num2str(t), '_', num2str(k)];
            end     
            
            sheet_opt = ['OptionOneInfo', appendix];
            try
                [num, txt, raw] = xlsread(filename, sheet_opt);
                [L, C] = size(raw);
                for i = 1:L
                    fd = raw{i, 1};
                    v  = raw{i, 2};
                    if isnan(v), continue; end
                    if isempty(v), continue; end
                    obj.optinfo.(fd) = v;
                end
            catch e
                disp(e);
            end
            
            fromExcel@AssetOne(obj, filename, appendix);
        end
    end
end