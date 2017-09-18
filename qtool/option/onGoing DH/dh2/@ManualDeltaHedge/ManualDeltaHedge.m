classdef ManualDeltaHedge < handle
    %MANUALDELTAHEDGE 手动进行delta hedge
    %  给一个Delta值，然后调用函数进行hedge
    %  delta值的计算等工作，全部交给外部
    % ----------------------------------
    % cg，161108
    
    properties
        bookS@Book;  % 投资组合信息，只负责记录清楚就行了，原则上不参与策略逻辑
        % positions 有两个： 昨仓和今仓
        
        counterS@CounterHSO32;  % 下单S的柜台
        marketNo    = '1';         %交易市场
        stockCode   = '510050';   %证券代码       
        
        
        delta = 0; % 外部更新， 单位是： 元/元
        
        quoteS@QuoteStock;  % 从qms里挂上
        
    end
    
    methods
        function openfire(mdh)
            
            
        end
        
        function buy_once(obj, q)
            
        end
        
        function sell_once(obj, q)
            
        end
        
        function trade_once(obj, dir, q)
        
        end
             
        
    end
    
end

