classdef cs
% CS 分类统计　Classified Statistics
% 计算数据的分类统计属性
% 陆怀宝个人使用并维护
% Lu, Huaibao; 201307;　
% Cheng, Gang; 20140124; 添加注释并检查
    
    properties
 
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        [ category ]    = categorize( data );
        [ patterns,id ] = excldPa( patterns,sless );
        [ vscore_buy,earraybuy ] = patternscore( ppro );
        tagseries       = tagging( Bars, type, para );
        [ r ]           = tagging2( data, flag , kp);
        
        
        
        
    end
    
end

