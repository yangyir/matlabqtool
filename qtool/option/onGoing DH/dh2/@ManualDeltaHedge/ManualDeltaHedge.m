classdef ManualDeltaHedge < handle
    %MANUALDELTAHEDGE �ֶ�����delta hedge
    %  ��һ��Deltaֵ��Ȼ����ú�������hedge
    %  deltaֵ�ļ���ȹ�����ȫ�������ⲿ
    % ----------------------------------
    % cg��161108
    
    properties
        bookS@Book;  % Ͷ�������Ϣ��ֻ�����¼��������ˣ�ԭ���ϲ���������߼�
        % positions �������� ��ֺͽ��
        
        counterS@CounterHSO32;  % �µ�S�Ĺ�̨
        marketNo    = '1';         %�����г�
        stockCode   = '510050';   %֤ȯ����       
        
        
        delta = 0; % �ⲿ���£� ��λ�ǣ� Ԫ/Ԫ
        
        quoteS@QuoteStock;  % ��qms�����
        
    end
    
    methods
        function openfire(mdh)
            
            
        end
        
        function buy_once(obj, q)
            
        end
        
        function sell_once(obj, q)
            
        end
        
        function trade_once(obj, dir, q)
        
        end
             
        
    end
    
end

