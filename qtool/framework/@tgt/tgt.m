classdef tgt
% TGT 后验打分系统 ensembles a cluster of score methods.  
% each method returns a score for indicator test use.
% One could play lots of hit games with whose scores.
% -----------------------------------------------------
% ver1.0; Cheng,Gang; 20130409
    
    properties
    end
    
    methods (Access = 'private', Static = true, Hidden = false)
%         [k, kk]   = calck(sequence,semi_window_1, semi_window_2);
%         calckk;
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        score   = momentumStart( seq, window_param );
        [trendsig]= trendsignal(data,mu1,mu2,delay);
        [ score ] = maxPotentialDown(inSeq,varargin);
        [ score ] = maxPotentialUp( inSeq, varargin );
        [ score ] = potentialRet(   inSeq,varargin );
        [ score ] = realizedRet(    inSeq, varargin );
        [ score ] = maxRealizedDown(inSeq, varargin );
        [ score ] = maxRealizedUp(  inSeq, varargin );
        [ score ] = maxHoldingUp(   inSeq, varargin );
        [ score ] = maxHoldingDown( inSeq, varargin );
        [ score ] = holdingRet(     inSeq, varargin );
    end
    
end

