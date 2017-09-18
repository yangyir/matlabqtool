classdef CRsi < handle
    % 增量计算rsi, C表示表示指标写成了类
    % Relative Strength Index 相对强弱指数
    % 返回rsi和rs的数值（[nPeriod] 矩阵），作为元函数，只计算单资产
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.22
    
    
    properties
        bars ;
        nDay ;
        latest ;
        rsiVal ;
        rsVal ;
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CRsi( bars, nDay)
            obj.bars = bars ;
            obj.nDay = nDay ;
            obj.latest = bars.time(end) ;
            [ obj.rsiVal, obj.rsVal] = ind.rsi( bars.close, nDay) ;
            
        end
        
        
        
        %% 后续增量计算
        function  rsiNew(obj)
            
            if obj.bars.time(end) > obj.latest
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
                
                
                [nPeriod] = size(obj.bars.close, 1);
                nNew = nPeriod - nStart ;
                
                obj.rsiVal = [obj.rsiVal ; nan(nNew,1) ] ;
                obj.rsVal = [obj.rsVal ; nan(nNew,1) ] ;
                
                diffClose = [nan(1,1);  diff(obj.bars.close)];
                diffChg   = abs(diffClose);
                advances = diffChg;
                declines = diffChg;
                advances(diffClose < 0 ) = 0;
                declines(diffClose > 0 ) = 0;
                
                
                for jPeriod = nStart+1 : nPeriod
                    totalGain = sum(advances(jPeriod - obj.nDay+1:jPeriod,:));
                    totalLoss = sum(declines(jPeriod - obj.nDay+1:jPeriod,:));
                    obj.rsVal(jPeriod,1) = totalGain./totalLoss;
                    obj.rsiVal(jPeriod,1) = 100 - (100./(1+obj.rsVal(jPeriod,1)));
                end
                
                obj.latest = obj.bars.time(end) ;
            end ;
            
            
        end;
        
    end
end


