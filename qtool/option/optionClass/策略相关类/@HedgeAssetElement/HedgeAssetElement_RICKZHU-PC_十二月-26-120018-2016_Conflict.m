classdef HedgeAssetElement < handle
    % HedgeAssetElement 包含一个Asset Quote
    % 包含一些Hedge规则或者约束
    % 最大手数限制。
    % 每单手数
    % 方向。
    % 设置默认的自动规则。该规则为，按当前最新价挂单，按max(1, min(target_vol, min(10, 1/2盘口量)))挂单。
    properties
        asset_quote_ = [];
        max_size_ = 10;
        target_vol_ = 0;
        direction_ = 'buy';
        offset_ = 'open';
        auto_@logical = true;
    end
    
    methods
        function [obj] = initHedgeElement(obj, quote, max_size, target_vol, dir, offset, auto)
            % function [obj] = initHedgeElement(obj, quote, max_size, target_vol, dir, offset, auto)
            % quote, 各类quote对象
            % 
            obj.asset_quote_ = quote;
            obj.max_size_ = max_size;
            obj.target_vol_ = target_vol;
            obj.direction_ = dir;
            obj.offset_ = offset;
            obj.auto_ = auto;
        end
        
        function [ret, e] = generate_entrust(obj) 
            % [ret, e] = generate_entrust(obj) 
            % 依据规则构造委托单。
            if obj.target_vol_ > 0
                quote = obj.asset_quote_;
                quote.fillQuote;
                px = quote.last;
                fireline_vol = 0;
                if (abs(px - quote.bidP1) < 0.00001)
                    fireline_vol = quote.bidQ1;
                end
                
                if (abs(px - quote.askP1) < 0.00001)
                    fireline_vol = quote.askQ1;
                end
                
                vol = max(1, min(obj.target_vol_, min(10, fireline_vol / 2)));
                e = Entrust;
                mktNo = '1';
                e.fillEntrust(mktNo, quote.code, obj.direction_, px, vol, obj.offset_, quote.getName);
                ret = true;
                return;
            else
                e = Entrust;
                ret = false;
            end            
        end
        
        function [obj] = update_entrust(obj, e)
            obj.target_vol_ = obj.target_vol_ - e.dealVolume;
        end
        
        
    end
end