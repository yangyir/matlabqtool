classdef tgt2
% TGT ������ϵͳ ensembles a cluster of score methods.  
% each method returns a score for indicator test use.
% One could play lots of hit games with whose scores.
% tgt2��tgt���������ڣ�������������һ�������ǰ����Bars��TsMatrix
% ver1.0;   Cheng,Gang;     20130410
    
    properties
    end
    
    methods (Access = 'private', Static = true, Hidden = false)
        
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        score   = momentumStart(bars);
    end
    
end
