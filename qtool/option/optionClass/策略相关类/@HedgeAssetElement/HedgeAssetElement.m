classdef HedgeAssetElement < handle
    % HedgeAssetElement 包含一个Asset Quote
    % 包含一些Hedge规则或者约束
    % 最大手数限制。
    % 每单手数
    % 方向。
    % 设置默认的自动规则。该规则为，按当前最新价挂单，按max(1, min(target_vol, min(max_size, 1/2盘口量)))挂单。
    properties
        book_ = [];
        counter_ = [];
        asset_quote_ = [];
        max_size_ = 10;
        base_vol_ = 1;
        target_vol_ = 0;
        direction_ = 'buy';
        offset_ = 'open';
        auto_@logical = true;
        cur_entrust_@Entrust;
    end
    
    methods
        function [obj] = HedgeAssetElement()
            obj.book_ = [];
            obj.counter_ = [];
            obj.asset_quote_ = [];
            obj.max_size_ = 10;
            obj.base_vol_ = 1;
            obj.target_vol_ = 0;
            obj.direction_ = 'buy';
            obj.offset_ = 'open';
            obj.auto_ = true;
            obj.cur_entrust_ = Entrust;
        end                
        
        function [obj] = initHedgeElement(obj, book, counter, quote)
            obj.book_ = book;
            obj.counter_ = counter;
            obj.asset_quote_ = quote;
        end
        
        function [base_d] = base_delta(obj)
            %function [base_delta] = base_delta(obj)
            base_d = obj.base_vol_ * obj.element_hedge_delta;
        end
        
        function [target_d] = target_delta(obj)
            target_d = obj.target_vol_ * obj.element_hedge_delta;
        end
        
        function [delta] = element_hedge_delta(obj)
            %function [delta] = hedge_delta(obj)            
            sign = 1;
            switch obj.direction_
                case 'buy'
                    sign = 1;
                case 'sell'
                    sign = -1;
            end
            delta = sign * obj.asset_quote_.calcDollarDelta1;
        end
        
        function [obj] = setHedgeTarget(obj, target_vol)       
            if ~exist('target_vol', 'var')
                target_vol = 0;
            end
            obj.target_vol_ = target_vol;
        end
        
        function [obj] = setDirection(obj, dir)
            obj.direction_ = dir;
        end
        
        function [obj] = setOffsetFlag(obj, offset)
            obj.offset_ = offset;
        end
        
        function [obj] = setBaseVol(obj, vol)
            obj.base_vol_ = vol;
        end
        
        function [obj] = set_target_factor(obj, factor)
            if factor < 0
                obj.direction_ = obj.opposite_direction;
            end
            obj.target_vol_ = obj.base_vol_ * abs(factor);
        end
        
        function [dir] = opposite_direction(obj)
            switch obj.direction_
                case 'buy'
                    dir = 'sell';
                case 'sell'
                    dir = 'buy';
            end
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
        
        function [ret] = do_hedge_place_entrust(obj)
            [ret, obj.cur_entrust_] = obj.generate_entrust;
%             disp('test place hedge entrust');
%             obj.book_.push_pendingEntrust(obj.cur_entrust_);
%             return;
            if ret
                ret = obj.counter_.placeEntrust(obj.cur_entrust_);
                if ret
                    obj.book_.push_pendingEntrust(obj.cur_entrust_);
                end
            end
        end
        
        function [ret] = do_hedge_update_entrust(obj)
            ret = true;
            e = obj.cur_entrust_;
            if (e.is_valid)
                done = false;
                while ~done
                    ret = obj.counter_.queryEntrust(e);
                    if ret
                        ret = obj.update_entrust(e);
                        if e.is_entrust_closed
                            done = true;
                            obj.cur_entrust_ = Entrust;
                        else
                            obj.counter_.withdrawEntrust(e);
                            pause(1);
                        end
                    end
                end
            end
        end
        
        function [hedge_finished] = do_hedge_check_target(obj)
            %function [hedge_finished] = do_hedge_check_target(obj)
            hedge_finished = (obj.target_vol_ == 0);
        end
        
        function [ret] = is_same_asset(obj, asset_code)
            %function [ret] = is_same_asset(obj, asset_code)
            ret = false;
            if strcmp(obj.asset_quote_.code, asset_code)
                ret = true;
            end
        end
    end
end