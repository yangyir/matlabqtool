classdef QMS_TEST < handle
    % QMS : Quote Management System
    % ��װQuoteԴ�����ڸ��¼��������Լ���������������
    %--------------------------------
    % �콭 20160308
    
    properties
        % h5quote
        % internal quote table
        regular_timer_ = []; % ��ʱ�������ڶ��ڼ���vol surface
        callQuotes_@M2TK ; % call quote ����
        putQuotes_@M2TK ; % put quote ����
        optquotes_ = []; % ����ṹ
        ready_ = []; % ����������Ч
        impvol_surface_@VolSurface; % ��������������
        timer_interval_@double = 60; % Ĭ��ÿ���Ӽ���һ��
        hist_quotes_;   
        calc_tau_counter = 10;
    end
    
    methods
        %���캯��
        function self = QMS_TEST()
            self.impvol_surface_ = VolSurface; 
        end
        function [] = init(obj, file_path)
            % login H5 Quote system
            % make sure logout state.
            mktlogout
            pause(3)
            cd('D:\intern\5.���Ʒ�\optionStraddleTrading\');
            mktlogin
            pause(3)
            while 1
                [p, mat] = getCurrentPrice('510050', '1');
                if p(1) > 0
                    break;
                else
                    disp('����������');
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
            % ��¼��������            
            flds = fields(obj.optquotes_); 
            % ��Ȩ�ܸ���Ϊn
            n = length(flds);
            
            for i = 1:n
                slice_quote.(char(flds(i))) = obj.optquotes_.(char(flds(i))).getCopy();                
            end
            % ��ʷ����������
            hist_t = length(obj.hist_quotes_);
            % ���ӽ������鵽ĩβ
            % ����ʷΪ��
            if(hist_t < 1)
                temp(1) = slice_quote;
                obj.hist_quotes_ = temp;
            else
                obj.hist_quotes_(hist_t + 1) = slice_quote;            
            end
            
            
        end
        
        function [quotes, m2c, m2p] = init_call_put_mat(obj, file_path)
            % quotes ��һ���ṹ�����ԱΪ['quoteopt','code'] ����quote510050
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
                    % ��������ȡ��QuoteOpt Ԫ�ء�
                    optquote_element = optquote_m2tk.getByIndex(indexX, indexY);
                    if(optquote_element.is_obj_valid())
                        optquote_element.fillQuoteH5();
                    end                    
                end
            end
            % [mkt, level] = getCurrentPrice(code,marketNo);
            % marketNo: �Ϻ�֤ȯ������='1';���='2'; �Ͻ�����Ȩ='3';�н���='5'
            % mkt: 3*1��ֵ����, ����Ϊ���¼�,�ɽ���,����״̬(=0��ʾȡ������;=1��ʾδȡ������)
            % level: �̿�����(5*4����), ��1~4������Ϊί���,ί����,ί����,ί����
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
                disp('��Ȩ���鲻ȫ');
                % for test only
                obj.ready_ = true;
            else
                disp('������Ȩ����׼������')
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
                    % ��������ȡ��QuoteOpt Ԫ�ء�
                    optquote_element = optquote_m2tk.getByIndex(indexX, indexY);
                    % query quote
                    optquote_element.fillQuoteH5();
                    % M2TK �п�����ϡ�������Ҫ�ж�Ԫ���Ƿ���Ч
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
                    % ��������ȡ��QuoteOpt Ԫ�ء�
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
%             str = sprintf('calc rate �� %f\n', calc_rate);
%             disp(str);
%             
%             str = sprintf('nan impvol / calc rate �� %f, nan nodes: %d, calc nodes:%d. \n', nan_impvol_rate, nan_num, calc_num);
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
                    % ��������ȡ��QuoteOpt Ԫ�ء�
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