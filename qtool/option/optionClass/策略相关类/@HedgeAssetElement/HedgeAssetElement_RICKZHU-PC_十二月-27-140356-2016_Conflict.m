classdef HedgeAssetElement < handle
    % HedgeAssetElement 包含一个Asset Quote
    % 包含一些Hedge规则或者约束
    % 最大手数限制。
    % 每单手数
    % 方向。
    % 设置默认的自动规则。该规则为，按当前最新价挂单，按max(1, min(target_vol, min(10, 1/2盘口量)))挂单。
    properties
        book_ = [];
        counter_ = [];
        asset_quote_ = [];
        max_size_ = 10;
        target_vol_ = 0;
        direction_ = 'buy';
        offset_ = 'open';
        auto_@logical = true;
    end
    
    methods
        function [obj] = HedgeAssetElement()
            obj.book_ = [];
            obj.counter_ = [];
            obj.asset_quote_ = [];
            obj.max_size_ = 10;
            obj.target_vol_ = 0;
            obj.direction_ = 'buy';
            obj.offset_ = 'open';
            obj.auto_ = true;
        end                
        
        function [obj] = initHedgeElement(obj, book, counter, quote)
            obj.book_ = book;
            obj.counter_ = counter;
            obj.asset_quote_ = quote;
        end
        
        function [obj] = initHedgeElement(obj, quote, max_size, target_vol)
            if ~exist('max_size', 'var')
                max_size = 10;
            end
            
            if ~exist('target_vol', 'var')
                target_vol = 0;
            end
            
            obj.asset_quote_ = quote;
            obj.max_size_ = max_size;
            obj.target_vol = target_vol;
        end
        
        function [obj] = setDirection(obj, dir)
            obj.direction_ = dir;
        end
        
        function [obj] = setOffsetFlag(obj, offset)
            obj.offset_ = offset;
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
        
        function [ret] = update_entrust(obj, e)
            ret = false;
            if strcmp(e.instrumentCode, obj.asset_quote_.code)
                obj.target_vol_ = obj.target_vol_ - e.dealVolume;
                ret = true;
            end            
        end        
        
        function [ret] = do_hedge_place_entrust(obj, counter, book)
            
        end
        
        function [ret] = do_hedge_update_entrust(obj)
            
        end
        
        function [hedge_finished] = do_hedge_check_target(obj)
            
        end
    end
end