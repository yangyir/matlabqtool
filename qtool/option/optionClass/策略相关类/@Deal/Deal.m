
% Deal 对应下单后的单个成交
%    以CTP的成交回报为例：
%     uint64_t trade_id_;
%     char code_[64];
%     int direction_;
%     int open_close_;
%     double price_;
%     uint32_t  amount_;
%     char trade_time_[64];
%     char  order_sys_id_[64];
%     int  trade_type_;
%     int  hedge_flag_;
%     int  market_type_;
%     暂时没有在交易中使用。
classdef Deal < handle
    properties
        entrust_no_; % 对应的Entrust
        deal_no_;    % Trade No
        code_;       % 标的代码
        name_;       % 标的名称        
        instrument_ ; % 标的类别
        settle_time_;% 交割期
        direction_;  % 委托方向
        offset_;     % 开平方向
        price_;     % 成交价
        volume_;   % 成交数量        
        amount_;    % 成交额
        time_;      % 成交时间
        is_passive_ = 1; % 0 - 主动成交， 1 - 被动成交
        fee_;        % 手续费
    end
    
    methods
        % set 各属性方法,主要是方向和开平
        function [obj] = set.direction_(obj, vin)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'buy', 'b', '买'}                
                        vout = 1;
                    case {'2', 'sell', 's', '卖'}
                        vout = -1;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else  % 不规则输入，如nan
                vout = 0;
            end                
            obj.direction_ = vout;                     
        end
        
        function [obj] = set.offset_(obj, vin)
            if isa(vin, 'char')
                switch vin
                    case {'1', 'open', 'o', '开', '开仓'}  % 开仓
                        vout = 1;
                    case {'2', 'close', 'c', '平', '平仓'}  % 平仓
                        vout = -1;
                    otherwise
                        vout = 0;
                end
            elseif isa(vin, 'double')
                vout = vin;
            else
                vout = 0;
            end
            obj.offset_ = vout;            
        end
        function [deal_time] = dealTime(obj)
            deal_time = obj.time_;
        end
        
        function [position] = deal_to_position(deal)
            %function [position] = deal_to_position(deal)
            % 把已经结束的entrust的deal信息转成一个Position
            position = Position;
            position.instrumentCode = deal.code_;
            position.instrumentName = deal.name_;
            position.volume         = deal.volume_ * deal.offset_; % 如果是平仓，则volume为负
            position.longShortFlag  = deal.offset_ * deal.direction_; % 开，则direction同longshort，关仓，则direction与longshort相反
            position.faceCost       = deal.amount_ * deal.direction_; % 这里算的是成本，如果卖，则是负成本
            position.avgCost        = position.faceCost / position.volume; % 平均成本   
            position.feeCost        = deal.fee_;
        end
        
        function [newobj] = getCopy(obj)
            eval( ['newobj = ', class(obj), ';']  );
            flds    = fields( obj );
            
            for i = 1:length(flds)
                fd          = flds{i};
                if isa(newobj.(fd), 'handle')
                    try
                        newobj.(fd) = obj.(fd).getCopy;
                    catch e
                        newobj.(fd) = obj.(fd);
                    end
                else
                    newobj.(fd) = obj.(fd);
                end                
            end
            
        end
    end
end