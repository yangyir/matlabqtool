classdef Calendar
    %CALENDAR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Access = 'public', Static = true, Hidden = false)
        % ȡ�úʹ洢����
        
        
        
        
        
        % ��������
        % xx�µĵ�n������daystr
        [ datnum ] = nthWeekdayOfMonth(n, daystr, mm, yyyy);
        
        
        
        
        
        
       
        
        
        % ����ʱ������
        [ n ] = daysNonWeekend(startDate, endDate);
        
        
        % ����DH��Դ�ĺ���
        [ n ] = dhDaysTrading( startDate, endDate, market);
        
    end
    
    
    %% ʵ�ú���
    methods(Access = 'public', Static = true, Hidden = false)
        
        function [ datnum ] = expirationETFopt( mm,yyyy)
            %50ETF��Ȩ�����գ������·ݵĵ��ĸ����������������ڼ���˳�ӣ�
            datnum = Calendar.nthWeekdayOfMonth(4, 'wed', mm, yyyy);
        end
        
        function [ datnum ] = expirationIF(mm, yyyy)
            % ��ָ�ڻ������գ���Լ�����·ݵĵ���������,�����ҷ�������˳��
            datnum = Calendar.nthWeekdayOfMonth(3, 'fri', mm, yyyy);            
        end
        
        
    end
    
end

