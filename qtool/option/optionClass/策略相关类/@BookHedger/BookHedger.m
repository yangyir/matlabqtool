classdef BookHedger < BookMonitor
    % BookHedger 首先是一个Monitor
    % 在Monitor的基础上，有柜台，有Hedge的规则.
    % hedgers 是HedgerAssetElement的序列，每个element包含hedge标的和hedge规则。
    properties
        counter_ = [];
        quoteS_;
        vol_surf_;
        r_ = 0.05;
        hedgers_@HedgeAssetElementArray; %考虑是否将正向和反向的Hedger分开。
    end
    
    methods
        function [obj] = BookHedger(book)
            %function [obj] = BookHedger(book)
            obj = obj@BookMonitor(book);
            obj.counter_ = [];
            obj.hedgers_ = HedgeAssetElementArray;
        end
        
        function [obj] = attachCounter(obj, counter)
            %function [obj] = attachCounter(obj, counter)
            obj.counter_ = counter;
        end
        
        function [obj] = attachQuoteS(obj, quoteS)
            %function [obj] = attachQuoteS(obj, quoteS)
            obj.quoteS_ = quoteS;
        end
        
        function [obj] = attachVolSurf(obj, vs)
            %function [obj] = attachVolSurf(obj, vs)
            obj.vol_surf_ = vs;
        end
        
        function [obj] = clearHedgers(obj)
            %function [obj] = clearHedgers(obj)
            obj.hedgers_.clear_array;
        end
        
        function [obj] = attachHedger(obj, quote, direction, offset, target_vol)
            %function [obj] = attachHedger(obj, quote, direction, offset, target_vol)
            if ~exist('target_vol', 'var')
                target_vol = 0;
            end
            hedger = HedgeAssetElement;
            hedger.initHedgeElement(obj.book, obj.counter_,quote).setDirection(direction).setOffsetFlag(offset);
            hedger.setHedgeTarget(target_vol);
            obj.hedgers_.push(hedger);
        end
        
        function [obj] = updateHedger(obj, index, direction, offset, target_vol)
            %function [obj] = updateHedger(obj, index, direction, offset, target_vol)
            if ~exist('target_vol', 'var')
                target_vol = 0;
            end
            hedger = obj.hedgers_.node(index);
            hedger.setDirection(direction).setOffsetFlag(offset).setHedgeTarget(target_vol);
        end
        
        function [ret] = check_and_prepare_hedge(obj, target_delta)
            %function [ret] = check_and_prepare_hedge(obj)
            if ~exist('target_delta', 'var')
                target_delta = 0;
            end
            % 判断是否触发Hedge条件
            ret = obj.check_hedge_condition;
            if ret
                % 计算并安排Hedge方案
                ret = obj.arrange_hedge_target(target_delta);
            end
        end
        
        function [ret] = arrange_hedge_target(obj, target_delta)
            %function [ret] = arrange_hedge_target(obj, target_delta)
            % 计算hedge所需方向和数量
            % 只计算delta
            if ~exist('target_delta', 'var')
                 target_delta = 0; 
            end
            risk_delta = obj.risk_dollar_delta;
            need_hedge_delta = risk_delta - target_delta;
            min_delta = obj.hedgers_.delta;
            % 计算一套对冲方案
            factor = -1 * round(need_hedge_delta / min_delta);
            % 设置
            obj.hedgers_.arrange_target_factor(factor);
            ret = true;
        end
        
        function [delta] = getHedgeDelta(obj)
            %function [delta] = getHedgeDelta(obj)
            % 看当前可Hedge的Delta
            delta = 0;
            L = obj.hedgers_.count;
            for i = 1:L
                delta = delta + obj.hedgers_.node(i).target_delta;
            end
        end
        
        function [ret] = check_hedge_condition(obj)
            %function [ret] = check_hedge_condition(obj)
            obj.update_env(obj.quoteS_.last, obj.vol_surf_, obj.r_);
            ret = obj.check_risks;
        end
        
        function [ret] = place_hedge_entrusts(obj)
            %function [ret] = place_hedge_entrusts(obj)
            ret = obj.hedgers_.foreach_place;
        end
        
        function [ret] = query_hedge_entrust(obj)
            %function [ret] = query_hedge_entrust(obj)
            ret = obj.hedgers_.foreach_query;
        end
        
        function [ret] = check_hedge_result(obj)
            %function [ret] = check_hedge_result(obj)
            % 看对冲是否结束。
            ret = obj.hedgers_.foreach_check;
        end
        
        function [ret, entrustArray] = generateHedgeEntrusts(obj)
            %function [ret, entrustArray] = generateHedgeEntrusts(obj)
            entrustArray = EntrustArray;
            ret = false;
            L = obj.hedgers_.count;
            for i = 1:L
                [result,e] = obj.hedgers_.node(i).generate_entrust;
                if result
                    ret = true;
                    entrustArray.push(e);
                end
            end            
        end
                
        function loop_do_hedge(obj)
            hedge_done = false;
            while ~hedge_done
                obj.place_hedge_entrusts;
                pause(1);
                obj.query_hedge_entrust;
                pause(1);
                hedge_done = obj.check_hedge_result;
            end    
            % update book and structure;
            obj.book.query_pendingEntrusts(obj.counter_);
            obj.book.update_position_structure;
        end
    end
end