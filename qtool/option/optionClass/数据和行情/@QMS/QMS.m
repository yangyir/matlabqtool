classdef QMS < handle
    % QMS : Quote Management System
    % 包装Quote源，定期更新计算行情以及隐含波动率曲面
    %--------------------------------
    % 朱江 20160308
    % 吴云峰 20160801 针对wind接口增加一个wind初始化|timer_event_function将H5和Wind的进行区分
    
    properties
        % h5quote
        % internal quote table
        regular_timer_ = []; % 定时器，用于定期计算vol surface
        callQuotes_@M2TK ; % call quote 矩阵
        putQuotes_@M2TK ; % put quote 矩阵
        m2cOptOne@M2TK;
        m2pOptOne@M2TK;
        optquotes_ = []; % 行情结构
        futquotes_ = [];
        stkquotes_ = [];
        futmap_@QuoteMap;
        stkmap_@QuoteMap;
        ready_ = []; % 行情数据有效
        impvol_surface_@VolSurface; % 隐含波动率曲面
        timer_interval_@double = 60; % 默认每分钟计算一次
        calc_tau_counter = 10;
        hist_opt_quotes_;
        hist_fut_quotes_;
        hist_stk_quotes_;
        srcType@char = 'L2file';% 'L2file', 'H5', 'DH', 'W'
        stkParser@L2QuoteParser;
        optParser@L2QuoteParser;
        futParser@L2QuoteParser;
        
        historic_call_m2tk_@HistoricQuoteM2TK;
        historic_put_m2tk_@HistoricQuoteM2TK;
        save_to_file;
        eod_handler;
    end
    
    properties (Access = 'public')
        % tau 只对期权最有意义。由于总共有四个交割月份，将所有期权共同的计算放在Qms中
        % 计算一次后，对所有期权赋值来避免重复计算。
        currentDate = today;
        T;            % 1*4 的矩阵。
        tauInterday;  % 年化  1*4 , 每天只更新一次，init时做
        tauIntraday;  % 年化  1*1， 定时更新
        tauPrecise;   % 年化， == tauInterday + tauIntraday,  1*4， 赋值给所有的quoteopt.tau        
        daysOfYear;
    end
    
    methods
        %构造函数
        function self = QMS()
            self.impvol_surface_ = VolSurface;
            self.historic_call_m2tk_ = HistoricQuoteM2TK('call');
            self.historic_put_m2tk_ = HistoricQuoteM2TK('put');
            self.save_to_file = false;
        end
        
        % 从历史行情文件中播放。
        function obj = init_src_from_file(obj, opt_fn, stk_fn, fut_fn, opt_src, stk_src) %, fut_src)
            obj.srcType = 'L2file';
            [obj.optquotes_, obj.callQuotes_, obj.putQuotes_] = obj.init_call_put_mat(opt_fn);
            [obj.futquotes_, obj.futmap_] = obj.init_fut_map(fut_fn);
            [obj.stkquotes_, obj.stkmap_] = obj.init_stk_map(stk_fn);  
            
            % init historic quote for test
            obj.historic_call_m2tk_.init_by_quote_mat(obj.callQuotes_);
            obj.historic_put_m2tk_.init_by_quote_mat(obj.putQuotes_);
            obj.historic_call_m2tk_.load_from_file;
            obj.historic_put_m2tk_.load_from_file;
            
            % init opt tau
            obj.calc_tau();
            obj.update_opt_tau();     
            % init vol surface
            obj.impvol_surface_.init_from_qms(obj);        
            
            % init quote parsers.
            obj.optParser = L2QuoteParser;
            obj.optParser.init(opt_src, obj.optquotes_, 'o');
            obj.stkParser = L2QuoteParser;
            obj.stkParser.init(stk_src, obj.stkquotes_, 's');
%             obj.futParser = L2QuoteParser;
%             obj.futParser.init(fut_src, obj.futquotes_, 'f');
            
            % init timer
            obj.regular_timer_ = timer('Period', obj.timer_interval_,...
                'TimerFcn', @obj.replay_timer_function,...
                'BusyMode', 'drop',...
                'ExecutionMode', 'fixedSpacing',...
                'StartDelay', min(obj.timer_interval_,10));
            start(obj.regular_timer_);
            
        end
        
        %% init_test 先测试通过，再替换原有init函数
        function [] = init_test(obj, opt_fn, fut_fn, stk_fn)
            cd('C:\Users\Rick Zhu\Documents\Synology Cloud\intern\5.吴云峰\optionStraddleTrading\');
            obj.srcType = '';
            [obj.optquotes_, obj.callQuotes_, obj.putQuotes_] = obj.init_call_put_mat(opt_fn);
            [obj.futquotes_, obj.futmap_] = obj.init_fut_map(fut_fn);
            [obj.stkquotes_, obj.stkmap_] = obj.init_stk_map(stk_fn);
            
            % init historic quotes m2tk.
            obj.historic_call_m2tk_.init_by_quote_mat(obj.callQuotes_);
            obj.historic_put_m2tk_.init_by_quote_mat(obj.putQuotes_);
            obj.historic_call_m2tk_.load_from_file;
            obj.historic_put_m2tk_.load_from_file;

            % init OptionOne M2TK for call and put options. 
            obj.init_opt_ones();
            
            % init opt tau
            obj.calc_tau();
            obj.update_opt_tau();
            
            % init vol surface
            obj.impvol_surface_.init_from_qms(obj);
            
        end
        
        %% run_test 
        function [] = run_h5_test(obj)
            % login H5 Quote system
            % make sure logout state.
            obj.srcType = 'H5';
            mktlogout
            pause(3)            
            cd('C:\Users\Rick Zhu\Documents\Synology Cloud\intern\hequnTest\mktmatlab');
%             cd('D:\intern\5.吴云峰\optionStraddleTrading\');
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
            
            obj.ready_ = true;
            % init timer
            obj.regular_timer_ = timer('Period', obj.timer_interval_,...
                'TimerFcn', @obj.timer_event_function,...
                'BusyMode', 'drop',...
                'ExecutionMode', 'fixedSpacing',...
                'StartDelay', min(obj.timer_interval_,10));
            start(obj.regular_timer_);
        end
        
        %
        function [] = init_src(obj, src_type, opt_fn, fut_fn, stk_fn)
        end
        
        %% 该init针对H5行情
        function [] = init(obj, opt_fn, fut_fn, stk_fn)
            % login H5 Quote system
            % make sure logout state.
            obj.srcType = 'H5';
            mktlogout
            pause(3)
%             cd('D:\intern\5.吴云峰\optionStraddleTrading\');
% cd('C:\Users\Rick Zhu\Documents\Synology Cloud');
%             temp = pwd;
%             cd('C:\Users\Rick Zhu\Documents\Synology Cloud\intern\HequnTest\mktmatlab');
            
            mktlogin
            pause(3)
            
            obj.check_quote_avaiable;

            % init call put opt pricers store.
            [obj.optquotes_, obj.callQuotes_, obj.putQuotes_] = obj.init_call_put_mat(opt_fn);
            [obj.futquotes_, obj.futmap_] = obj.init_fut_map(fut_fn);
            [obj.stkquotes_, obj.stkmap_] = obj.init_stk_map(stk_fn);
            
            % init historic quotes m2tk.
            obj.historic_call_m2tk_.init_by_quote_mat(obj.callQuotes_);
            obj.historic_put_m2tk_.init_by_quote_mat(obj.putQuotes_);
%             obj.historic_call_m2tk_.load_from_file;
%             obj.historic_put_m2tk_.load_from_file;
            
            % init OptionOne M2TK for call and put options. 
            obj.init_opt_ones();
            
            % init opt tau
            obj.calc_tau();
            obj.update_opt_tau();
            
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
        
        %% 该函数是针对Wind行情
        function [m2tkCallQuote , m2tkPutQuote] = init_wind(obj, opt_fn, fut_fn, stk_fn)
            obj.srcType = 'WIND';
            
            [obj.optquotes_, obj.callQuotes_, obj.putQuotes_] = obj.init_call_put_mat(opt_fn);
            m2tkCallQuote = obj.callQuotes_;
            m2tkPutQuote  = obj.putQuotes_;
            
            [obj.futquotes_, obj.futmap_] = obj.init_fut_map(fut_fn);
            [obj.stkquotes_, obj.stkmap_] = obj.init_stk_map(stk_fn);
            obj.historic_call_m2tk_.init_by_quote_mat(obj.callQuotes_);
            obj.historic_put_m2tk_.init_by_quote_mat(obj.putQuotes_);
            
            obj.init_opt_ones();
            
            % init opt tau
            obj.calc_tau();
            obj.update_opt_tau();
            
            % init vol surface
            obj.impvol_surface_.init_from_qms(obj);
            
            % init timer
            obj.regular_timer_ = timer('Period', obj.timer_interval_,...
                'TimerFcn', @obj.timer_event_function,...
                'BusyMode', 'drop',...
                'ExecutionMode', 'fixedSpacing',...
                'StartDelay', max(obj.timer_interval_,120));
        end
        
        
        function [] = init_opt_ones(obj)
            obj.m2cOptOne = obj.callQuotes_.getCopy;
            obj.m2pOptOne = obj.putQuotes_.getCopy;
            
            nT = length(obj.callQuotes_.yProps);
            nK = length(obj.callQuotes_.xProps);
            
%             data1(nT, nK) = OptionOne;
%             data2(nT, nK) = OptionOne;

            obj.m2cOptOne.data = OptionOne;
            obj.m2pOptOne.data = OptionOne;
            
            for t = 1:nT
                for k = 1:nK
                    % 取quote出来
                    cquote = obj.callQuotes_.data(t,k);
                    pquote = obj.putQuotes_.data(t,k);
                    
                    % 生成 callOne， putOne， 挂进data里
                    call_one = OptionOne;
                    call_one.quote = cquote;
%                     ob1 = OrderBookPartial( 'ask', cquote.code);
%                     ob2 = OrderBookPartial( 'bid', cquote.code);
%                     ob1.iT = t;  ob2.iT = t;
%                     ob1.iK = k;  ob2.iK = k;                    
%                     call_one.askOrderBook = ob1;
%                     call_one.bidOrderBook = ob2;
                  
                    obj.m2cOptOne.data(t,k) = call_one;
                    
                    put_one = OptionOne;
                    put_one.quote = pquote;
%                     ob1 = OrderBookPartial( 'ask', pquote.code);
%                     ob2 = OrderBookPartial( 'bid', pquote.code);
%                     ob1.iT = t;  ob2.iT = t;
%                     ob1.iK = k;  ob2.iK = k;                    
%                     put_one.askOrderBook = ob1;
%                     put_one.bidOrderBook = ob2;
               
                    obj.m2pOptOne.data(t,k) = put_one;
%                     put_one = obj.m2pOptOne.data(t,k);
%                     put_one.quote = pquote;
                end
            end
        end
        

        function [] = attach_stock(obj, code, name, market)
            % code 是股票代码, market是市场信息 ‘sh’'sz'
            if(obj.stkmap_.contains(code))
                return;
            end
            quote = QuoteStock;
            quote.fillStockInfo(code, name, market);
            quote.fillQuoteH5;
            % add to struct
            varname = ['quotestk', code];
            obj.stkquotes_.(varname) = quote;
            
            % add to map
            obj.stkmap_.add(code, quote);
        end
        
        function [] = attach_future(obj, code, name, T)
            % code 是股票代码, market是市场信息 ‘sh’'sz'
            if(obj.stkmap_.contains(code))
                return;
            end
            quote = QuoteFuture;
            quote.fillFutureInfo(code, name, T);
            quote.fillQuoteH5;
            % add to struct
            varname = ['quotefut', code];
            obj.futquotes_.(varname) = quote;
            % add to map
            obj.futmap_.add(code, quote);            
        end
        
        function [] = Start(obj)
            if isempty(obj.regular_timer_)
                disp('定时器无效')
                return;
            end

            start(obj.regular_timer_);
        end
        
        function [] = Stop(obj)
            if isempty(obj.regular_timer_)
                return;
            end            
            stop(obj.regular_timer_);
        end
        
        function [] = Update(self)
            self.query_quotes(self.optquotes_);
        end
        
        function [running] = isRunning(obj)
            if isempty(obj.regular_timer_)
                running = false;
                return;
            end
            switch obj.regular_timer_.Running
                case 'on'
                    running = true;
                case 'off'
                    running = false;
            end
        end
        
        function [] = release(obj)
            stop(obj.regular_timer_);
            delete(obj.regular_timer_);
            mktlogout
        end
    end
    
    methods (Access = private)
        function [] = store_all_quotes(obj)
            obj.hist_opt_quotes_ = obj.store_quote(obj.optquotes_, obj.hist_opt_quotes_);
            obj.hist_fut_quotes_ = obj.store_quote(obj.futquotes_, obj.hist_fut_quotes_);
            obj.hist_stk_quotes_ = obj.store_quote(obj.stkquotes_, obj.hist_stk_quotes_);
        end
        
        function [stored_quotes] = store_quote(obj, quote, stored_quotes)
            % 记录截面行情            
            flds = fields(quote); 
            % 期权总个数为n
            n = length(flds);
            
            for i = 1:n
                slice_quote.(char(flds(i))) = quote.(char(flds(i))).getCopy();                
            end
            
            % 历史行情截面个数
            hist_t = length(stored_quotes);
            % 附加截面行情到末尾
            % 若历史为空
            if(hist_t < 1)
                temp(1) = slice_quote;
                stored_quotes = temp;
            else
                stored_quotes(hist_t + 1) = slice_quote;            
            end
            
            
        end
        
        function [quotes, m2c, m2p] = init_call_put_mat(obj, file_path)
            % quotes 是一个结构，其成员为['quoteopt','code'] 例：quote510050
            [quotes, m2c, m2p] =  QuoteOpt.init_from_sse_excel( file_path );
            
            obj.T = obj.init_opt_T(m2c);
            
            if strcmp(obj.srcType, 'H5')
                % query opt quote.
                obj.query_m2tk_quotes(m2c);
                % query put opt quote.
                obj.query_m2tk_quotes(m2p);
            end
        end
        
        function [expirationTime] = init_opt_T(obj, optquote_m2tk)
            
            nK = length(optquote_m2tk.xProps);
            nT = length(optquote_m2tk.yProps);
            expirationTime = zeros(1, nT);
            for t = 1:nT
                for k = 1:nK
                    % 从容器中取出QuoteOpt 元素。
                    optquote_element = optquote_m2tk.data(t, k);
                    if(optquote_element.is_obj_valid())
                        expirationTime(t) = optquote_element.T;
                        break;
                    end                                        
                end
            end
        end
        
        function [futquotes, fut_map] = init_fut_map(obj, file_path)
            [futquotes, fut_map] = QuoteFuture.init_from_excel(file_path);
            if(strcmp(obj.srcType, 'H5'))
                obj.query_quotes(futquotes);
            end
        end
        
        function [stkquotes, stk_map] = init_stk_map(obj, file_path)
            [stkquotes, stk_map] = QuoteStock.init_from_excel(file_path);
            if(strcmp(obj.srcType, 'H5'))
                obj.query_quotes(stkquotes);
            end
        end
        
        function [] = query_quotes(obj, quotes)
            flds = fields(quotes); 
            % 品种总个数为n
            n = length(flds);            
            for i = 1:n
                quotes.(char(flds(i))).fillQuoteH5();                
            end
        end
        
        function [] = query_m2tk_quotes(obj, optquote_m2tk)
            [~, x_size] = size(optquote_m2tk.xProps);
            [y_size, ~] = size(optquote_m2tk.yProps);
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
                pause(1);
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
        
        function [] = calc_opt_quotes(obj)
            flds = fields(obj.optquotes_); 
            % 品种总个数为n
            n = length(flds);            
            for i = 1:n
                optquote_element = obj.optquotes_.(char(flds(i)));
                if(optquote_element.is_obj_valid() && optquote_element.is_quote_valid())
                    obj.generate_calc_quote(optquote_element);
                end
            end
            
        end
        
        function [] = generate_calc_quote(obj, optquote_element)
            optquote_element.calc_last_all_greeks();
            optquote_element.calc_ask_all_greeks();
            optquote_element.calc_bid_all_greeks();            
        end
        
        function [avaiable ] = check_quote_avaiable(obj)
            [p, mat] = getCurrentPrice('510050', '1');
            
            if p(1) > 0
                avaiable = 1;
            else
                avaiable = 0;
                disp('行情有问题');
            end
        end
        
        %% 将Wind的timer和H5的timer进行区分
        function [] = timer_event_function(self, obj, event)
            
            % WIND
            srcType = self.srcType;
            if ismember( srcType , { 'W';'WIND';'wind';'w'} )
                nT = length(self.callQuotes_.yProps);
                nK = length(self.callQuotes_.xProps);
                for t = 1:nT
                    for k = 1:nK
                        % store quote to historic quotes.
                        call_quote = self.callQuotes_.data(t,k);
                        put_quote = self.putQuotes_.data(t,k);
                        self.historic_call_m2tk_.record_t_k_quote(t,k,call_quote);
                        self.historic_put_m2tk_.record_t_k_quote(t,k,put_quote);
                    end
                end
                self.impvol_surface_.sync_ImpVol();
                self.calc_tau_counter = self.calc_tau_counter - 1;
                if(self.calc_tau_counter ==  0)
                    self.update_tau;
                    self.calc_tau_counter = 10;
                end
                disp('qms wind timer event');
                return;
            end
            
            % H5
            quote_valid = self.check_quote_avaiable;
            if ~quote_valid
                return;
            end
            
            if(self.ready_)
                self.query_m2tk_quotes(self.callQuotes_);
                self.query_m2tk_quotes(self.putQuotes_);
                % 更新期货
                self.query_quotes(self.futquotes_);
                % 更新股票
                self.query_quotes(self.stkquotes_);
                self.calc_m2tk_quote(self.callQuotes_);
                self.calc_m2tk_quote(self.putQuotes_);
                
                nT = length(self.callQuotes_.yProps);
                nK = length(self.callQuotes_.xProps);
                save_to_file = true;
                
                for t = 1:nT
                    for k = 1:nK
                        % store quote to historic quotes.
                        call_quote = self.callQuotes_.data(t,k);
                        put_quote = self.putQuotes_.data(t,k);
                        c = self.historic_call_m2tk_.record_t_k_quote(t,k,call_quote);
                        p = self.historic_put_m2tk_.record_t_k_quote(t,k,put_quote);
                        if (c == 1 || p == 1) 
                            save_to_file = false;
                            self.save_to_file = false;
                        end
                    end
                end
                
                if save_to_file
                    if ~self.save_to_file
                        self.historic_call_m2tk_.save_to_file();
                        self.historic_put_m2tk_.save_to_file();
                        self.save_to_file = true;
                        
                        % 日末执行清理外接清理逻辑
                        if self.is_end_of_day
                            if ~isempty(self.eod_handler)
                                fun = self.eod_handler;
                                fun();
                            end
                        end
                    end
                end
                
                self.impvol_surface_.sync_ImpVol();
                self.calc_tau_counter = self.calc_tau_counter - 1;
                if(self.calc_tau_counter ==  0)
                    self.update_tau;
                    self.calc_tau_counter = 10;
                end
            end
            disp('qms timer event');
        end
        
        function [] = replay_timer_function(self, obj, event)
            %更新期权
            if(~isempty(self.optParser))
                self.optParser.parse();
            end
            %更新股票
            if(~isempty(self.stkParser))
                self.stkParser.parse();
            end
            %更新期货
            if(~isempty(self.futParser))
                self.futParser.parse();
            end
            
            nT = length(self.callQuotes_.yProps);
            nK = length(self.callQuotes_.xProps);
            for t = 1:nT
                for k = 1:nK
                    % store quote to historic quotes.
                    call_quote = self.callQuotes_.data(t,k);
                    put_quote = self.putQuotes_.data(t,k);
                    self.historic_call_m2tk_.record_t_k_quote(t,k,call_quote);
                    self.historic_put_m2tk_.record_t_k_quote(t,k,put_quote);
                end
            end
%             self.calc_opt_quotes();
%             
%             self.impvol_surface_.sync_ImpVol();
            self.calc_tau_counter = self.calc_tau_counter - 1;
            if(self.calc_tau_counter ==  0)
                self.update_tau;
                self.calc_tau_counter = 10;
            end
            
        end
    
        function [] = update_tau(obj)
            ct = Calendar_Test.GetInstance();
            obj.tauIntraday = (1 - ct.trading_fraction_day(now)) / obj.daysOfYear;
            obj.tauPrecise = obj.tauInterday + obj.tauIntraday;
           obj.update_opt_tau();            
        end
        
        function [] = update_opt_tau(obj)
            % 更新期权的剩余时间，QMS负责计算，这里只负责更新
            nK = length(obj.callQuotes_.xProps);
            nT = length(obj.callQuotes_.yProps);
            
            for t = 1:nT;
                for k = 1:nK;
                    % 从容器中取出QuoteOpt 元素。
                    optquote_element = obj.callQuotes_.data(t, k);
                    if(optquote_element.is_obj_valid())
                        optquote_element.tau = obj.tauPrecise(t);
                    end                    
                    optquote_element = obj.putQuotes_.data(t, k);
                    if(optquote_element.is_obj_valid())
                        optquote_element.tau = obj.tauPrecise(t);
                    end
                end
            end            
        end
        
        function [obj] = calc_tau(obj)
            % 计算期权的剩余时间。
%         tauInterday;  % 年化  1*4 , 每天只更新一次，init时做
%         tauIntraday;  % 年化  1*1， 定时更新
%         tauPrecise;   % 年化， == tauInterday + tauIntraday,  1*4， 赋值给所有的quoteopt.tau        
           ct = Calendar_Test.GetInstance();
           obj.daysOfYear = ct.calc_trading_days_of_year(obj.T(1), obj.T(end));
           nT = length(obj.T);
           Interday = zeros(1, nT);
           for i = 1:nT
               t = obj.T(i);
               Interday(i) = ct.trading_days(obj.currentDate, t);
           end
           obj.tauInterday = Interday / obj.daysOfYear;
           obj.tauIntraday = (1 - ct.trading_fraction_day(now)) / obj.daysOfYear;
           obj.tauPrecise = obj.tauInterday + obj.tauIntraday;
        end
        
        function [eod] = is_end_of_day(obj)
            % 检验是否eod，避免搞错
            tm = now - floor(now);
            if (tm>=9.5/24  && tm<=15/24)
                eod = false
                return;
            end
            eod = true;
        end
        
    end

    
    methods (Access = public, Static = true)
        [] = demo;
        
        [] = quote_file_src_demo;
        
          
        function set_quoteopt_ptr_in_position_array(positionArray, quoteOpts)
            % 给position.quote挂上正确的quoteOpt
           
            % quotes 是一个struct，里面命名如下：quoteopt10000394
%             L = length(positionArray.node);
            L = positionArray.latest;
            for i = 1:L
                p = positionArray.node(i);
                code = p.instrumentCode;
                % 判断code是期权
                if length(code)<8
                    continue;
                end
                % 其他情形不判断，直接try
                try
                    % 这一句： tmp = quoteOpts.quoteopt10000394;
                    eval( [ 'tmp = quoteOpts.quoteopt' code ';' ] ) ;
                    %　在 position上挂quoteopt指针
                    p.quote = tmp;
                    p.instrumentName = tmp.optName;
                catch
                    disp('quote指针赋值失败');
                end
            end
        end
      

    end
end