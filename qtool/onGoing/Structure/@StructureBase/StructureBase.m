classdef StructureBase
%STRUCTUREBASE 基类
% 衍生类包括：
%     Vanilla
%     VanillaPlus
%     Bermuda
% 程刚；140622

    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
      
        
        % 标量
        asofDate; % t
        expDate; % T
        remDaysT; % T-t (交易日)
        remDaysN; % T-t (自然日）
        
        % 算式
        payoffFomula; % 可以直接eval的算式
        
        
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % 计算剩余日期
        calcRemDays;
    end
    
end

