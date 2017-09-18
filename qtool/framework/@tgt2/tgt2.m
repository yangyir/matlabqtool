classdef tgt2
% TGT 后验打分系统 ensembles a cluster of score methods.  
% each method returns a score for indicator test use.
% One could play lots of hit games with whose scores.
% tgt2与tgt的区别在于，后者输入量是一般变量，前者是Bars或TsMatrix
% ver1.0;   Cheng,Gang;     20130410
    
    properties
    end
    
    methods (Access = 'private', Static = true, Hidden = false)
        
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        score   = momentumStart(bars);
    end
    
end
