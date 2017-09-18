classdef QMS_TEST < handle
    % QMS : Quote Management System
    % 包装Quote源，定期更新计算行情以及隐含波动率曲面
    %--------------------------------
    % 朱江 20160308
    
    properties
        % h5quote
        % internal quote table
        regular_timer_ = []; % 定时器，用于定期计算vol surface
        callQuotes_@M2TK ; % call quote 矩阵
        putQuotes_@M2TK ; % put quote 矩阵
        optquotes_ = []; % 行情结构
        ready_ = []; % 行情数据有效
        impvol_surface_@VolSurface; % 隐含波动率曲面
        timer_interval_@double = 60; % 默认每分钟计算一次
        hist_quotes_;   
        calc_tau_counter = 10;
    end
    
    methods
        %构造函数
        function self = QMS_TEST()
            self.impvol_surface_ = VolSurface; 
        end
        function [] = init(obj, file_path)
            % login H5 Quote system
            % make sure logout state.
            mktlogout
            pause(3)
            cd('D:\intern\5.吴云峰\optionStraddleTrading\');
            mktlogin
            pause(3)
            while 1
                [p, mat] = getCurrentPrice('510050', '1');
                if p(1) > 0
                    break;
                else
                    disp('行情有问题');
                    pause(1)
                end
            end
            
            % init call put opt pricers store.
            [obj.optquotes_, obj.callQuotes_, obj.putQuotes_] = obj.init_call_put_mat(file_path);
            
            % wait quote ready
            obj.wait_quote_ready();
            
            % init vol surface
            obj.impvol_surface_.init_from_qms(obj);
            
            % init timer
            obj.regular_timer_ = timer('Period', obj.timer_interval_,...
                'TimerFcn', @obj.timer_event_function,...
                'BusyMode', 'drop',...
                'ExecutionMode', 'fixedSpacing',...
                'StartDelay', min(obj.timer_interval_,10));
            start(obj.regular_timer_);
        end

        
        function [] = release(obj)
            stop(obj.regular_timer_);
            delete(obj.regular_timer_);
            mktlogout
        end
    end
    
    methods (Access = private)
        function [obj] = store_quote(obj)
            % 记录截面行情            
            flds = fields(obj.optquotes_); 
            % 期权总个数为n
            n = length(flds);
            
            for i = 1:n
                slice_quote.(char(flds(i))) = obj.optquotes_.(char(flds(i))).getCopy();                
            end
            % 历史行情截面个数
            hist_t = length(obj.hist_quotes_);
            % 附加截面行情到末尾
            % 若历史为空
            if(hist_t < 1)
                temp(1) = slice_quote;
                obj.hist_quotes_ = temp;
            else
                obj.hist_quotes_(hist_t + 1) = slice_quote;            
            end
            
            
        end
        
        function [quotes, m2c, m2p] = init_call_put_mat(obj, file_path)
            % quotes 是一个结构，其成员为['quoteopt','code'] 例：quote510050
            [quotes, m2c, m2p] =  QuoteOpt.init_from_sse_excel( file_path );
            % query opt quote.
            obj.query_m2tk_quotes(m2c);
            % query put opt quote.
            obj.query_m2tk_quotes(m2p);            
        end
        
        function [] = query_m2tk_quotes(obj, optquote_m2tk)
            [~, x_size] = size(optquote_m2tk.xProps);
            [y_size, ~] = size(optquote_m2tk.yProps);
            current = now;
            for indexX = 1:x_size;
                for indexY = 1:y_size;
                    % 从容器中取出QuoteOpt 元素。
                    optquote_element = optquote_m2tk.getByIndex(indexX, indexY);
                    if(optquote_element.is_obj_valid())
                        optquote_element.fillQuoteH5();
                    end                    
                end
            end
            % [mkt, level] = getCurrentPrice(code,marketNo);
            % marketNo: 上海证券交易所='1';深交所='2'; 上交所期权='3';中金所='5'
            % mkt: 3*1数值向量, 依次为最新价,成交量,交易状态(=0表示取到行情;=1表示未取到行情)
            % level: 盘口数据(5*4矩阵), 第1~4列依次为委买价,委买量,委卖价,委卖量
            % [mkt, level] = getCurrentPrice(optquote_element.code, '3');
        end
        
        function [] = wait_quote_ready(obj)
            max_loop_time = 10;
            obj.ready_ = obj.check_opt_quotes();
            loop_time  = 0;
            while(~obj.ready_ && loop_time < max_loop_time)
                pause(3);
                obj.ready_ = obj.check_opt_quotes();
                loop_time = loop_time + 1;
            end
            if(~obj.ready_)
                disp('期权行情不全');
                % for test only
                obj.ready_ = true;
            else
                disp('所有期权行情准备就绪')
            end
        end
        
        function [is_ready] = check_opt_quotes(obj)
            is_ready = obj.check_m2tk_status(obj.callQuotes_);
            disp('call check result:');
            disp(is_ready);
            if(is_ready)
                is_ready = obj.check_m2tk_status(obj.putQuotes_);
                disp('put check result:');
                disp(is_ready);                
            end
        end
        
        function [is_ready] = check_m2tk_status(obj, optquote_m2tk)
            % check quote status.
            is_ready = true;
            [~, x_size] = size(optquote_m2tk.xProps);
            [y_size, ~] = size(optquote_m2tk.yProps);
            for indexX = 1:x_size;
                for indexY = 1:y_size;
                    % 从容器中取出QuoteOpt 元素。
                    optquote_element = optquote_m2tk.getByIndex(indexX, indexY);
                    % query quote
                    optquote_element.fillQuoteH5();
                    % M2TK 中可能是稀疏矩阵，需要判断元素是否有效
                    if(optquote_element.is_obj_valid())
                        str = sprintf('valid element, x: %d, y: %d\n', indexX, indexY);
                        disp(str);
                        if(~optquote_element.is_quote_valid())
                            str = sprintf('quote invalid element, x: %d, y: %d\n', indexX, indexY);
                            disp(str);
                            
                            is_ready = false;
                            continue;
                        end
                    end
                end
            end
%             is_ready = true;            
        end
        
        function [] = calc_m2tk_quote(obj, optquote_m2tk)
            [~, x_size] = size(optquote_m2tk.xProps);
            [y_size, ~] = size(optquote_m2tk.yProps);
%             total_num = x_size * y_size;
%             str = sprintf('total nodes of calc m2tk :%d \n', total_num);
%             disp(str);
            
            calc_num = 0;
            nan_num = 0;
            for indexX = 1:x_size;
                for indexY = 1:y_size;
                    % 从容器中取出QuoteOpt 元素。
                    optquote_element = optquote_m2tk.getByIndex(indexX, indexY);
                    if(optquote_element.is_obj_valid() && optquote_element.is_quote_valid())
                        obj.generate_calc_quote(optquote_element);
                        if(isnan(optquote_element.impvol))
                            nan_num = nan_num + 1;
                        end
                        calc_num = calc_num + 1;
                    end
                end
            end       
            
%             calc_rate = calc_num / total_num;
%             nan_impvol_rate = nan_num / calc_num;
%             str = sprintf('calc rate ； %f\n', calc_rate);
%             disp(str);
%             
%             str = sprintf('nan impvol / calc rate ； %f, nan nodes: %d, calc nodes:%d. \n', nan_impvol_rate, nan_num, calc_num);
%             disp(str);

        end
        
        function [] = generate_calc_quote(obj, optquote_element)
            optquote_element.calc_last_all_greeks();
            optquote_element.calc_ask_all_greeks();
            optquote_element.calc_bid_all_greeks();            
        end
        
        function [] = timer_event_function(self, obj, event)
            if(self.ready_)
                self.query_m2tk_quotes(self.callQuotes_);
                self.query_m2tk_quotes(self.putQuotes_);
                self.store_quote();
                self.calc_m2tk_quote(self.callQuotes_);
                self.calc_m2tk_quote(self.putQuotes_);
                self.impvol_surface_.sync_ImpVol();
                self.calc_tau_counter = self.calc_tau_counter - 1;
                if(self.calc_tau_counter ==  0)
                    self.update_tau;
                    self.calc_tau_counter = 10;
                end
            end
            disp('qms timer event');
        end
    
        function [] = update_tau(self)
            [~, x_size] = size(self.callQuotes_.xProps);
            [y_size, ~] = size(self.callQuotes_.yProps);
            current = now;            
            for indexX = 1:x_size;
                for indexY = 1:y_size;
                    % 从容器中取出QuoteOpt 元素。
                    optquote_element = self.callQuotes_.getByIndex(indexX, indexY);
                    if(optquote_element.is_obj_valid())
                        optquote_element.currentDate = current;                        
                    end                    
                    optquote_element = self.putQuotes_.getByIndex(indexX, indexY);
                    if(optquote_element.is_obj_valid())
                        optquote_element.currentDate = current;                        
                    end                    
                    
                end
            end            
        end
        
    end
    
    
    methods (Access = public, Static = true)
        [] = demo;
    end
end