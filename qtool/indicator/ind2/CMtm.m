classdef CMtm < handle
    % 增量计算mtm, C表示表示指标写成了类

    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.25
    
    
    properties
        bars ;
        latest ;
        price ; 
        nday ;
 
        mtm ; 
        
        
        
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CMtm(bars, price, nday )
            obj.bars    = bars ;
            obj.latest  = bars.time(end) ;
            obj.nday    = nday ;
            obj.price   = price ; 
 
            
            [ obj.mtm ] = ind.mtm( price, nday ) ;

        end
        
        
        
        %% 后续增量计算
        function  mtmAdd(obj)
            
            if obj.bars.time(end) > obj.latest
                
                
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                [nPeriod] = size(obj.bars.close, 1);
 
                
                for i = nStart+1:nPeriod
                    
                    obj.mtm(i)          = (obj.price(i) - obj.price(i - obj.nday) );
                     
                    
                end ;
                
                obj.latest = obj.bars.time(end) ;
                
            end;
            
        end
    end
    
end 
    
    
