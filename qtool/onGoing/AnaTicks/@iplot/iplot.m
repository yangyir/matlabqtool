% version 1.0, luhuaibao, 2014.5.30
% ������ͼ


 

classdef iplot
    
    properties
        
    end
    
    
    methods (Access = 'private', Static = true, Hidden = true )

        
        
    end
    
    
    methods (Access = 'public', Static = true, Hidden = false )
 
        % ��ʱ�����У�ts1, ts2, �������᣻���ử���ߵĲ�
        ts1_ts2_spread( ts1, ts2 )
        
        % hist ts������ͼ�ϱ����λ��
        ihist( ts ) ;
        
        % plotyy
        [ax,h1,h2] = plotYY( data,setplot ) 
        
        % һ�����ݣ���������ͼ�����ᣬ�ߣ���ɫ����΢��ͼ�����ᣬ������ɫ��
        [h1, h2] = plotyyDiffCum( data, datatype, data_x )
        
        % ��ͼvalue����ͼ����hist����ͼ������ͳһ
        [ h1, h2 ] = value_hist( vector, times, tickvalue )
        
    end
    
    
end
