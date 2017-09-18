classdef VanillaPlus < StructureBase
    %VANILLAPLUS 单一underlier，多结构组合
    % 
    
    properties
        underCode; 
        underName; % string

        
        % 标量
        asofDate; % t
        expDate; % T
        remDaysT; % T-t (交易日)
        remDaysN; % T-t (自然日）
        rfr;  % r, risk free rate
        
        % 数组        
        volSurf;
        vanillas; % 若干个Vanilla类的变量, 只需要type，K，position就行了，其它的从此类
        
        
        
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % constructor
        
        
        
        plotPayoff
    end
    
end

