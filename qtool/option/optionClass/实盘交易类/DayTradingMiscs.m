classdef DayTradingMiscs < handle
    % 统计
    % ----------------
    % 朱江
    properties
        % 挂开
        openLimitCounters@double = 0;
        % 挂平
        closeLimitCounters@double = 0;
        % 成开
        filledOpenCounters@double = 0;
        % 成平
        filledCloseCounters@double = 0;
    end
    
    methods
        function disp(obj)
            disp(['挂开： ', num2str(obj.openLimitCounters)]);
            disp(['挂平： ', num2str(obj.closeLimitCounters)]);
            disp(['成开： ', num2str(obj.filledOpenCounters)]);
            disp(['成平： ', num2str(obj.filledCloseCounters)]);
        end
        
        function newobj = getCopy(obj)
            eval( ['newobj = ', class(obj), ';']  );
            flds    = fields( obj );
            
            for i = 1:length(flds)
                fd          = flds{i};
                newobj.(fd) = obj.(fd);
            end    
        end
        
        function obj = handle_open_limit(obj, vol) 
            if(vol > 0)
                obj.add_open_limits(vol);
            end
        end
        
        function obj = handle_close_limit(obj, vol)
            if(vol > 0)
                obj.add_close_limits(vol);
            end
        end
        
        function obj = handle_open_filled(obj, deal_vol, withdraw_vol)
            if ~exist('withdraw_vol', 'var')
                withdraw_vol = 0;
            end
            
            if((deal_vol >= 0) && (withdraw_vol >= 0))
                % filled case : decrease open_limit counters, and increase
                % filled_open counters
                obj.add_filled_open(deal_vol);
                obj.sub_open_limits((deal_vol + withdraw_vol));
            end
        end
        
        function obj = handle_close_filled(obj, deal_vol, withdraw_vol)
            if ~exist('withdraw_vol', 'var')
                withdraw_vol = 0;
            end
            
            if((deal_vol >= 0) && (withdraw_vol >= 0))
                % filled case : decrease open_limit counters, and increase
                % filled_open counters
                obj.add_filled_close(deal_vol);
                obj.sub_close_limits((deal_vol + withdraw_vol));
            end
        end
    end
    
    methods (Access = 'private')
        function obj = add_open_limits(obj, vol)
            obj.openLimitCounters = obj.openLimitCounters + vol;
        end
        
        function obj = add_close_limits(obj, vol)
            obj.closeLimitCounters = obj.closeLimitCounters + vol;
        end
        
        function obj = sub_open_limits(obj, vol)
            obj.openLimitCounters = obj.openLimitCounters - vol;
        end
        
        function obj = sub_close_limits(obj, vol)
            obj.closeLimitCounters = obj.closeLimitCounters - vol;
        end
        
        function obj = add_filled_open(obj, vol)
            obj.filledOpenCounters = obj.filledOpenCounters + vol;
        end
        
        function obj = add_filled_close(obj, vol)
            obj.filledCloseCounters = obj.filledCloseCounters + vol;
        end
    end
end