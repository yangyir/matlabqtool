classdef Basket
    %BASKET һ�����ʲ�������Ȩ
    %   Detailed explanation goes here
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        underNum; % �����ʲ�������������
        
        % ���ʲ�
        underCode;
        underName;
        underP; %S0
        bsVol; %����
        
        
        % ���ʲ�
        volSurf;  % ��ʵ��һ���ߣ����У���vol�� ST )  
        corr; % ����Ծ��󣬼�����Ҫ
        
        
        % ����Ȩ
        type; % c, p
        strike;  % K        
        position; % +1, -1, Ĭ��+1

    end
    
    methods
    end
    
end

