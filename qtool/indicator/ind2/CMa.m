classdef CMa < handle
    % 增量计算ma, C表示表示指标写成了类
    % Moving Average
    % [maVal] = ma(price,lag,flag)
    % price：（多个）资产价格序列
    % lag：   滞后阶数 （默认 10）
    % flag：  MA计算方法
    %         e = 指数移动平均
    %         0 = 简单移动平均
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.23
    
    
    properties
        bars ;
        latest ;
        price ; 
        lag ;
        flag ; 
        maVal ;
 
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CMa( bars, price, lag, flag )
            
            obj.bars    = bars ;
            
            if isempty(bars.latest )
                obj.latest  = bars.time(end) ;
            else 
                obj.latest  = bars.time(bars.latest) ;
            end ;
            
            obj.price   = price ; 
            obj.lag     = lag ;
            obj.flag    = flag ; 
            
            obj.maVal = ind.ma( price, lag, flag ) ; 
            
        end
        
        
        
        %% 后续增量计算
        function  maAdd(obj)
            
            % 以下要更新
            if isempty(obj.bars.latest )
                timeNow = obj.bars.time(end) ;
            else 
                timeNow = obj.bars.time(obj.bars.latest) ;
            end ;
            
            % 下句要更新
            if timeNow > obj.latest
                
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                % 这句要更新
                if isempty(obj.bars.latest )
                    [nPeriod] = size(obj.bars.close, 1);
                    obj.latest = obj.bars.time(end) ;
                else 
                    [nPeriod] = obj.bars.latest;
                    obj.latest = obj.bars.time(obj.bars.latest) ;
                end ;
            
                nNew = nPeriod - nStart ;
                
                obj.maVal = [obj.maVal ; nan(nNew,1) ] ;
                
                param = 2/( obj.lag+1 );
                
                for jPeriod = nStart+1 : nPeriod
                    if obj.flag == 'e'
                        obj.maVal(jPeriod,1) = obj.maVal(jPeriod-1,1) + param*(obj.price(jPeriod,1)- obj.maVal(jPeriod-1,1));
                    elseif obj.flag == 0
                        obj.maVal(jPeriod,1) = obj.maVal(jPeriod-1,1) + 1/obj.lag*( obj.price(jPeriod,1) - obj.price(jPeriod - obj.lag ,1 ) );
                    end ; 
                    
                end; 
 
                
                
            end ;
            
            
        end;
        
    end
end


