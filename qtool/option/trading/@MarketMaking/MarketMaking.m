classdef MarketMaking < handle
    %MARKETMAKING �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    
          % ���Ա����еĹ�����
    properties(SetAccess = 'public', Hidden = false ) % ���Ե�ʱ��public��Ϊ�˷���
         % �˻���Ϣ, ��ʼ�����ٸĶ�
        counter@CounterHSO32;       % O32��̨
        book@Book   = Book;         % Ͷ�������Ϣ��ֻ�����¼��������ˣ�ԭ���ϲ���������߼�
        bookfn;

        % ��Ȩ����
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        
        % 
        volsurf@VolSurface;
        
        % �ֻ�����, 50ETF
        quoteS@QuoteStock;
        
        
        % OptionOne;
        m2tkCallOne@OptionOneM2TK;
        m2tkPutOne@OptionOneM2TK;
    end

    
    
    properties
        callOne@OptionOne;
        putOne@OptionOne;
        optOne@OptionOne;
    end
    
    methods
        [optOne]    = set_optOne( obj, iT, K , type);
        [callOne]   = set_callOne(obj, iT, K);
        [putOne]    = set_putOne(obj, iT, K);
        
        function set_counters(obj)
           % ��һ��m2tkCallOne��m2tkPutOne�������µ�counter
           % ˼����OptionOne��handle���࣬������޸Ļ�������˴���Ӱ�죡��
           % ��ʱֻ��һ��counter�������н��ף�û�󰭣��Ժ�һ��Ҫ��
           L = length( obj.m2tkCallOne.xProps);
           for iT = 1:4
               for iK = 1:L
                   obj.m2tkCallOne.data(iT, iK).counter = obj.counter;
                   obj.m2tkPutOne.data(iT, iK).counter  = obj.counter;
               end
           end           
        end
    end
    
end

