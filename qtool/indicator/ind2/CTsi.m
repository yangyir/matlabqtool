classdef CTsi < handle
    % 增量计算Tsi, C表示表示指标写成了类
 
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.25
    
    
    properties
        bars ;
        latest ;
        price ; 
        tsi ; 
        fast ; 
        slow ; 
        emaslow ; 
        emafast ; 
        emaabsslow ; 
        emaabsfast ; 
 
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CTsi(bars, price, fast, slow )
            obj.bars    = bars ;
            obj.latest  = bars.time(end) ;
            obj.price   = price ; 
            obj.fast    = fast ; 
            obj.slow    = slow ; 
 
            
            [obj.tsi ] = ind.tsi ( obj.price, fast, slow );
            
            momentum = [zeros(1,1); diff(obj.price) ];
            absMomentum = abs(momentum);
            
            obj.emaslow = ind.ma(momentum, slow,'e') ; 
            obj.emafast = ind.ma( obj.emaslow, fast, 'e') ; 
            
            obj.emaabsslow = ind.ma(absMomentum,slow,'e') ; 
            obj.emaabsfast = ind.ma( obj.emaabsslow, fast, 'e') ; 
 
        end
        
        
        
        %% 后续增量计算
        function  tsiAdd(obj)
            
            if obj.bars.time(end) > obj.latest
                
                
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                [nPeriod] = size(obj.bars.close, 1);
                
                nAdd = nPeriod - nStart ;
                
                obj.tsi         = [ obj.tsi ; nan(nAdd,1) ] ;
                obj.emaslow     = [ obj.emaslow ; nan(nAdd,1) ];
                obj.emafast     = [ obj.emafast ; nan(nAdd,1) ];
                obj.emaabsslow  = [ obj.emaabsslow ; nan(nAdd,1) ];
                obj.emaabsfast  = [ obj.emaabsfast ; nan(nAdd,1) ];
              
                
                for i = nStart+1:nPeriod
                    obj.emaslow(i) = obj.emaslow(i-1) + 2/(obj.slow+1)*( (obj.price(i) - obj.price(i-1)) - obj.emaslow(i-1) );
                    obj.emafast(i) = obj.emafast(i-1) + 2/(obj.fast+1)*( obj.emaslow(i) - obj.emafast(i-1) );
                    obj.emaabsslow(i) = obj.emaabsslow(i-1) + 2/(obj.slow+1)*( abs(obj.price(i) - obj.price(i-1)) - obj.emaabsslow(i-1) );
                    obj.emaabsfast(i) = obj.emaabsfast(i-1) + 2/(obj.fast+1)*( obj.emaabsslow(i) - obj.emaabsfast(i-1) );                    
                    obj.tsi(i) = 100*obj.emafast(i)/obj.emaabsfast(i);
                end ;
                obj.latest = obj.bars.time(end) ;
                
            end;
            
        end
    end
    
end 
    
    
