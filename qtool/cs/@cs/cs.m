classdef cs
% CS ����ͳ�ơ�Classified Statistics
% �������ݵķ���ͳ������
% ½��������ʹ�ò�ά��
% Lu, Huaibao; 201307;��
% Cheng, Gang; 20140124; ���ע�Ͳ����
    
    properties
 
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        [ category ]    = categorize( data );
        [ patterns,id ] = excldPa( patterns,sless );
        [ vscore_buy,earraybuy ] = patternscore( ppro );
        tagseries       = tagging( Bars, type, para );
        [ r ]           = tagging2( data, flag , kp);
        
        
        
        
    end
    
end

