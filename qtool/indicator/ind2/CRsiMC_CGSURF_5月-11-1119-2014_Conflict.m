classdef CRsiMC < handle
    % 增量计算rsi, C表示表示指标写成了类
    % Relative Strength Index 相对强弱指数
    % 返回rsi和rs的数值（[nPeriod] 矩阵），作为元函数，只计算单资产
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.22
    
    
    properties
        bars ;
        nDay ;
        latest ;
        rsi ;
        var0 ; 
        var1 ; 
        var4 ; 
        
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CRsiMC( bars, nDay)
            obj.bars = bars ;
            obj.nDay = nDay ;
            obj.latest = bars.time(end) ;
            [ obj.rsi, obj.var0, obj.var1, obj.var4 ] = ind.rsiMC( bars, nDay) ;
            
        end
        
        
        
        %% 后续增量计算
        function  rsiMCAdd(obj)
            
            if obj.bars.time(end) > obj.latest
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                [nPeriod] = size(obj.bars.close, 1);
                nAdd = nPeriod - nStart ;
                
                vclose = obj.bars.close ;
                difclose = [nan ; diff(vclose) ] ;
                absDifClose = abs(difclose) ;
                
                obj.var0 = [ obj.var0; nan( nAdd, 1 ) ] ;
                obj.var1 = [ obj.var1; nan( nAdd, 1 ) ];
                obj.var4 = [ obj.var4; nan( nAdd, 1 ) ];
                obj.rsi  = [ obj.rsi ; nan( nAdd, 1 ) ] ;
                
                for i = nStart+1:nPeriod
                    obj.var0(i,1) = obj.var0(i-1,1) + ( difclose(i,1) - obj.var0(i-1,1))/obj.nDay ;
                    obj.var1(i,1) = obj.var1(i-1,1) + ( absDifClose(i,1) - obj.var1(i-1,1) )/obj.nDay ;
                    if obj.var1(i,1) ~= 0
                        obj.var4(i,1) = obj.var0(i,1)/obj.var1(i,1) ;
                    else
                        obj.var4(i,1) = 0 ;
                    end;
                end ;
                
                obj.rsi(nStart+1:nPeriod) =  50 * ( obj.var4(nStart+1:nPeriod) + 1 ) ;
                
                obj.latest = obj.bars.time(end) ;
            end ;
            
            
        end;
        
    end
end


