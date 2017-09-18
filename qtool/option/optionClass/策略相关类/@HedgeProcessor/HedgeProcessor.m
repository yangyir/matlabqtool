classdef HedgeProcessor < handle
    % HedgeProcessor 类
    % 对Book序列进行Hedge
    % 提供手动和自动的操作方式。
    % 提供timer，定时监视，在触发对冲时停止Timer， 对冲完成后启动Timer
    
    properties
        regular_timer_ = []; % hedge timer. 
        timer_interval_@double = 60; % 默认每分钟计算一次
        book_hedgers_@BookHedgerArray;
    end
    
    methods
        function [obj] = HedgeProcessor()
            obj.book_hedgers_ = BookHedgerArray;
            obj.regular_timer_ = timer('Period', obj.timer_interval_,...
                'TimerFcn', @obj.hedge_timer_function,...
                'BusyMode', 'drop',...
                'ExecutionMode', 'fixedSpacing',...
                'StartDelay', min(obj.timer_interval_,10));
        end
        
        function [] = hedge_timer_function(obj)
            need_hedge = obj.foreach_check_hedge();
            if need_hedge
                % stop timer
                obj.Stop;
                % do hedge
                obj.do_hedge();                
                % start timer
                obj.Start;
            end
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
        
        function [obj] = attachBookHedger(obj, hedger)
            if ~isa(hedger, 'BookHedger')
                disp('not a book hedger');
            end
            obj.book_hedgers_.push(hedger);
        end
        
        function [obj] = clearAllHedgers(obj)
            obj.book_hedgers_.clear_array;
        end
        
        function [ret] = for_each_check_hedge(obj)
            ret = obj.book_hedgers_.foreach_check_hedge;
        end
        
        function [ret] = do_hedge(obj)
            hedge_done = false;
            while ~hedge_done
                obj.book_hedgers_.foreachHedge;
                pause(3);
                obj.book_hedgers_.foreachQuery;
                pause(3);
                hedge_done = obj.book_hedgers_.foreachCheckHedgeDone;
            end
            ret = hedge_done;
        end
    end
    
end