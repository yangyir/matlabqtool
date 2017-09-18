classdef CKdj < handle
    % 增量计算kdj, C表示表示指标写成了类
    % 计算kdj值
    % 输入
    %【数据】ClosePrice,HighPrice,Lowprice
    %【参数】 nday移动平均回溯天数（自然数）
    %输出，kdj 计算的kdj值
    % *********************************************************************
    % version 1.0, luhuaibao,  2013.10.24
    
    
    properties
        bars ;
        latest ;
        k ;
        d ;
        j ;
        nday ;
        m ;
        l ;
        rsv ;
        
        
        
    end
    
    %%
    methods
        %% 初始化
        function obj = CKdj(bars, nday, m, l )
            obj.bars    = bars ;
            obj.latest  = bars.time(end) ;
            obj.nday    = nday ;
            obj.m       = m ;
            obj.l       = l ;
            
            [obj.k,obj.d,obj.j] = ind.kdj( bars.close, bars.high , bars.low,nday, m, l) ;
            
            
            llv         = llow( obj.bars.low, 1 );
            hhv         = hhigh( obj.bars.high, 1 );
            
            
            
            obj.rsv = ( (obj.bars.close - llv )./(hhv -llv )) * 100;
            
            
            
        end
        
        
        
        %% 后续增量计算
        function  kdjAdd(obj)
            
            if obj.bars.time(end) > obj.latest
                
 
                nStart = find( obj.bars.time == obj.latest, 1, 'last' ) ;
 
                
                [nPeriod] = size(obj.bars.close, 1);
                
                nAdd = nPeriod - nStart ;
                obj.k = [ obj.k ; nan(nAdd,1) ] ;
                obj.d = [ obj.d ; nan(nAdd,1) ] ;
                obj.j = [ obj.j ; nan(nAdd,1) ] ;
                
                
                obj.rsv = [ obj.rsv ; nan(nAdd,1) ] ;
                
                
                para1=(obj.m-1)/obj.m;
                para2=1/obj.m;
                para3 = (obj.l-1)/obj.l;
                para4 = 1/obj.l;
                
                
                for i = nStart+1:nPeriod
                    
                    obj.rsv(i) = ( (obj.bars.close(i) - min(obj.bars.low(end-obj.nday+1:end,1) ))./(max(obj.bars.high(end-obj.nday+1:end,1) ) -min(obj.bars.low(end-obj.nday+1:end,1) ) )) * 100;
                    obj.k(i)=para1*obj.k(i-1)+para2*obj.rsv(i);
                    obj.d(i)=para3*obj.d(i-1)+para4*obj.k(i);
                    obj.j(i)=3*obj.d(i)-2*obj.k(i);
                    
                end ;
                
                
                
                obj.latest = obj.bars.time(end) ;
                
            end ;
            
            
        end;
        
    end
end


