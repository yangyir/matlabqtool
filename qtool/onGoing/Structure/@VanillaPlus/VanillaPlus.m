classdef VanillaPlus < StructureBase
    %VANILLAPLUS ��һunderlier����ṹ���
    % 
    
    properties
        underCode; 
        underName; % string

        
        % ����
        asofDate; % t
        expDate; % T
        remDaysT; % T-t (������)
        remDaysN; % T-t (��Ȼ�գ�
        rfr;  % r, risk free rate
        
        % ����        
        volSurf;
        vanillas; % ���ɸ�Vanilla��ı���, ֻ��Ҫtype��K��position�����ˣ������ĴӴ���
        
        
        
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % constructor
        
        
        
        plotPayoff
    end
    
end

