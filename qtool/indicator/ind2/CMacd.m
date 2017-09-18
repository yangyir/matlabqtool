classdef CMacd < handle
    % 增量计算macd, C表示表示指标写成了类

    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.23
    
    
    properties
        bars ;
        latest ;
        price ; 
        long ; 
        short ; 
        maLen ;
        dif ; 
        dea ; 
        Cdea ; 
        macd ; 
        ema_short ; 
        ema_long ; 
 
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CMacd(bars, price, long, short,maLen)
            obj.bars    = bars ;
            
            if isempty(bars.latest )
                obj.latest  = bars.time(end) ;
            else 
                obj.latest  = bars.time(bars.latest) ;
            end ;
            
            obj.price   = price ; 
            obj.long    = long ; 
            obj.short   = short ; 
            obj.maLen   = maLen ; 
            
           [ obj.dif, ~, obj.macd ] = ind.macd(price, long, short,maLen ) ; 
           
           obj.Cdea = CMa( obj.bars, obj.dif, maLen, 'e' ) ; 
           obj.dea = obj.Cdea.maVal ; 
           
           % 调用CMa ; 
           obj.ema_short = CMa( obj.bars, obj.price, obj.short, 'e' ) ;
           obj.ema_long = CMa( obj.bars, obj.price, obj.long, 'e' ) ;
        end
        
        
        
        %% 后续增量计算
        function  macdAdd(obj)
            
            % 以下要更新
            if isempty(obj.bars.latest )
                timeNow = obj.bars.time(end) ;
            else 
                timeNow = obj.bars.time(obj.bars.latest) ;
            end ;
            
            % 下句要更新
            if timeNow > obj.latest
                
                if isempty(obj.bars.latest )
%                     [nPeriod] = size(obj.bars.close, 1);
                    obj.latest = obj.bars.time(end) ;
                else 
%                     [nPeriod] = obj.bars.latest;
                    obj.latest = obj.bars.time(obj.bars.latest) ;
                end ;
                
%                 nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
%                 [nPeriod] = size(obj.bars.close, 1);
%                 nNew = nPeriod - nStart ;
                
%                 obj.dif     = [obj.dif ; nan(nNew,1) ] ;
%                 obj.dea     = [obj.dea ; nan(nNew,1) ] ;
%                 obj.macd    = [obj.macd ; nan(nNew,1) ] ;
                obj.ema_short.price = obj.bars.close ; 
                obj.ema_long.price = obj.bars.close ; 
                obj.ema_short.maAdd() ; 
                obj.ema_long.maAdd() ; 
                
                obj.dif     = obj.ema_short.maVal - obj.ema_long.maVal ;
                
 
                obj.Cdea.price = obj.dif ; 
                obj.Cdea.maAdd() ; 
                obj.dea = obj.Cdea.maVal ; 
                obj.macd    = obj.dif - obj.dea ;
               


            end ;
            
            
        end;
        
    end
end


