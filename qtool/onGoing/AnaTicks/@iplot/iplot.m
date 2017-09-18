% version 1.0, luhuaibao, 2014.5.30
% 画各种图


 

classdef iplot
    
    properties
        
    end
    
    
    methods (Access = 'private', Static = true, Hidden = true )

        
        
    end
    
    
    methods (Access = 'public', Static = true, Hidden = false )
 
        % 两时间序列，ts1, ts2, 画在左轴；右轴画两者的差
        ts1_ts2_spread( ts1, ts2 )
        
        % hist ts，并在图上标出分位数
        ihist( ts ) ;
        
        % plotyy
        [ax,h1,h2] = plotYY( data,setplot ) 
        
        % 一组数据，画出积分图（左轴，线，蓝色）和微分图（右轴，柱，黄色）
        [h1, h2] = plotyyDiffCum( data, datatype, data_x )
        
        % 左图value，右图竖版hist，两图纵坐标统一
        [ h1, h2 ] = value_hist( vector, times, tickvalue )
        
    end
    
    
end
