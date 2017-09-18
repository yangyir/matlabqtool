classdef mv
% MV 是函数包，用于算“移动***值” moving values  
% 也就是说，站在某一点上，向历史看n格（window）。
% 都是后验值。
% 注意：输出向量的前n格统一补成nan
% 只是一些基础函数。包括：
% 距离位移类：distance，shift，d2s, s2d
% 波动类：atr，vol，extreme,半vol,skewness，kurtosis
% 平均求和类：avg,sum
% 其他：k，kk，连阴，连阳
% -----------------------------------------------------
% ver1.0; Cheng,Gang; 20130723
    
    properties
    end
    
    methods (Access = 'private', Static = true, Hidden = false)
    end
    
    %% 距离位移类：distance，shift，d2s, s2d
    methods (Access = 'public', Static = true, Hidden = false)
        [outSeq]    = dist(     inSeq, window );
        [outSeq] 	= shift(    inSeq, window );
        [outSeq]    = s2d(      inSeq, window );
        [outSeq]    = d2s(      inSeq, window );
%         [ score ] = holdingRet(     inSeq, varargin );
        [outSeq]    = delta(    inSeq, window );
    end
    
    %% 波动类：atr，vol,半vol,skewness，kurtosis
    methods (Access = 'public', Static = true, Hidden = false)
        [ outSeq ]  = vol(      inSeq, window );
        [ outSeq ]  = upvol(    inSeq, window );
        [ outSeq ]  = dnvol(    inSeq, window );
        [ outSeq ]  = skew(     inSeq, window );
        [ outSeq ]  = kurt(     inSeq, window );
    end
    
    %% 平均求和类：avg,sum
    methods (Access = 'public', Static = true, Hidden = false)
        [ outSeq ]  = avg(      inSeq, window );
        [ outSeq ]  = stddev(   inSeq, window );
        [ outSeq ]  = sum(   inSeq, window );

        
    end
    
    %% 平滑类
     methods (Access = 'public', Static = true, Hidden = false)
        % 指数平滑exponential smoothed moving average
         [ outSeq ]  = expSmooth(      inSeq, alpha ); 
         % 二次指数平滑
         
         % 三次指数平滑
        
         
         % 指数衰减
         [ outSeq ]  = expDecay(      inSeq, days ); 
        
    end
    
    %% 其他：k，kk，连阴，连阳
    methods (Access = 'public', Static = true, Hidden = false)
        [ outSeq ]  = k(        inSeq, window);
        [ k, kk ]   = kkk(      inSeq, win1, win2);
        [ outSeq ]  = upup(     inSeq );
        [ outSeq ]  = dndn(     inSeq );
    end
    
end
