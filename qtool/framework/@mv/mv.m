classdef mv
% MV �Ǻ������������㡰�ƶ�***ֵ�� moving values  
% Ҳ����˵��վ��ĳһ���ϣ�����ʷ��n��window����
% ���Ǻ���ֵ��
% ע�⣺���������ǰn��ͳһ����nan
% ֻ��һЩ����������������
% ����λ���ࣺdistance��shift��d2s, s2d
% �����ࣺatr��vol��extreme,��vol,skewness��kurtosis
% ƽ������ࣺavg,sum
% ������k��kk������������
% -----------------------------------------------------
% ver1.0; Cheng,Gang; 20130723
    
    properties
    end
    
    methods (Access = 'private', Static = true, Hidden = false)
    end
    
    %% ����λ���ࣺdistance��shift��d2s, s2d
    methods (Access = 'public', Static = true, Hidden = false)
        [outSeq]    = dist(     inSeq, window );
        [outSeq] 	= shift(    inSeq, window );
        [outSeq]    = s2d(      inSeq, window );
        [outSeq]    = d2s(      inSeq, window );
%         [ score ] = holdingRet(     inSeq, varargin );
        [outSeq]    = delta(    inSeq, window );
    end
    
    %% �����ࣺatr��vol,��vol,skewness��kurtosis
    methods (Access = 'public', Static = true, Hidden = false)
        [ outSeq ]  = vol(      inSeq, window );
        [ outSeq ]  = upvol(    inSeq, window );
        [ outSeq ]  = dnvol(    inSeq, window );
        [ outSeq ]  = skew(     inSeq, window );
        [ outSeq ]  = kurt(     inSeq, window );
    end
    
    %% ƽ������ࣺavg,sum
    methods (Access = 'public', Static = true, Hidden = false)
        [ outSeq ]  = avg(      inSeq, window );
        [ outSeq ]  = stddev(   inSeq, window );
        [ outSeq ]  = sum(   inSeq, window );

        
    end
    
    %% ƽ����
     methods (Access = 'public', Static = true, Hidden = false)
        % ָ��ƽ��exponential smoothed moving average
         [ outSeq ]  = expSmooth(      inSeq, alpha ); 
         % ����ָ��ƽ��
         
         % ����ָ��ƽ��
        
         
         % ָ��˥��
         [ outSeq ]  = expDecay(      inSeq, days ); 
        
    end
    
    %% ������k��kk������������
    methods (Access = 'public', Static = true, Hidden = false)
        [ outSeq ]  = k(        inSeq, window);
        [ k, kk ]   = kkk(      inSeq, win1, win2);
        [ outSeq ]  = upup(     inSeq );
        [ outSeq ]  = dndn(     inSeq );
    end
    
end
