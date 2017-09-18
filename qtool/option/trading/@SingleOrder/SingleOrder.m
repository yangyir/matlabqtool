classdef SingleOrder < handle
    %SINGLEORDER ֻ��һ��
    
      % ���Ա����еĹ�����
    properties(SetAccess = 'public', Hidden = true ) % ���Ե�ʱ��public��Ϊ�˷���
         % �˻���Ϣ, ��ʼ�����ٸĶ�
        counter@CounterHSO32;       % O32��̨
        book@Book   = Book;         % Ͷ�������Ϣ��ֻ�����¼��������ˣ�ԭ���ϲ���������߼�
        bookfn;
        
        % ��Ȩ����
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        
        % OptionOne;
        m2tkCallOne@M2TK;
        m2tkPutOne@M2TK;
        
    end
    
    properties
        call@QuoteOpt;
        put@QuoteOpt;
        opt@QuoteOpt;
        
        callOne@OptionOne;
        putOne@OptionOne;
        
    end
    
    methods
        
         % ��ĩ���رղ���
        function end_day(obj)
%             obj.counter.logout;
            if ~isempty(obj.bookfn)
                obj.book.toExcel(obj.bookfn);
            else
                obj.book.toExcel;
            end
        end
        
        
        
        set_opt(obj, iT, K , type);
        trade_opt(obj, direc, volume, offset, px);
        
        
        function set_call(obj, iT, K_call)
            % ������quote���ó�����Ҫ��call
            if ~exist('iT', 'var'), iT = 1;             end
            if ~exist('K_call','var'), K_call  = 2;     end
            
            iK          = obj.m2tkCallQuote.getIdxByPropvalue_X( K_call );
            obj.call    = obj.m2tkCallQuote.getByIndex(iK, iT);
            
            fprintf('ʹ��call��%s\n', obj.call.optName);
        end
        
        function set_put(obj, iT, K_put)
            % ������quote���ó�����Ҫ��put
            if ~exist('iT', 'var'), iT = 1;             end
            if ~exist('K_put','var'), K_put  = 2;       end
            
            iK          = obj.m2tkPutQuote.getIdxByPropvalue_X( K_put );
            obj.put     = obj.m2tkPutQuote.getByIndex(iK, iT);
            
            fprintf('ʹ��put��%s\n', obj.put.optName);
        end
        
        trade_call(obj, direc, volume, offset )
        trade_put(obj, direc, volume, offset )
            
        
      
    end
    
end

