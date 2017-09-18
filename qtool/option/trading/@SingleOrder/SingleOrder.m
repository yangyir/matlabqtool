classdef SingleOrder < handle
    %SINGLEORDER 只下一单
    
      % 策略必须有的公共量
    properties(SetAccess = 'public', Hidden = true ) % 调试的时候public，为了方便
         % 账户信息, 初始化后不再改动
        counter@CounterHSO32;       % O32柜台
        book@Book   = Book;         % 投资组合信息，只负责记录清楚就行了，原则上不参与策略逻辑
        bookfn;
        
        % 期权行情
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
        
         % 日末，关闭策略
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
            % 从所有quote里拿出来需要的call
            if ~exist('iT', 'var'), iT = 1;             end
            if ~exist('K_call','var'), K_call  = 2;     end
            
            iK          = obj.m2tkCallQuote.getIdxByPropvalue_X( K_call );
            obj.call    = obj.m2tkCallQuote.getByIndex(iK, iT);
            
            fprintf('使用call：%s\n', obj.call.optName);
        end
        
        function set_put(obj, iT, K_put)
            % 从所有quote里拿出来需要的put
            if ~exist('iT', 'var'), iT = 1;             end
            if ~exist('K_put','var'), K_put  = 2;       end
            
            iK          = obj.m2tkPutQuote.getIdxByPropvalue_X( K_put );
            obj.put     = obj.m2tkPutQuote.getByIndex(iK, iT);
            
            fprintf('使用put：%s\n', obj.put.optName);
        end
        
        trade_call(obj, direc, volume, offset )
        trade_put(obj, direc, volume, offset )
            
        
      
    end
    
end

