classdef StructureBase
%STRUCTUREBASE ����
% �����������
%     Vanilla
%     VanillaPlus
%     Bermuda
% �̸գ�140622

    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
      
        
        % ����
        asofDate; % t
        expDate; % T
        remDaysT; % T-t (������)
        remDaysN; % T-t (��Ȼ�գ�
        
        % ��ʽ
        payoffFomula; % ����ֱ��eval����ʽ
        
        
    end
    
    methods(Access = 'public', Static = false, Hidden = false)
        % ����ʣ������
        calcRemDays;
    end
    
end

