classdef MarketMaking < handle
    %MARKETMAKING 此处显示有关此类的摘要
    %   此处显示详细说明
    
    
          % 策略必须有的公共量
    properties(SetAccess = 'public', Hidden = false ) % 调试的时候public，为了方便
         % 账户信息, 初始化后不再改动
        counter@CounterHSO32;       % O32柜台
        book@Book   = Book;         % 投资组合信息，只负责记录清楚就行了，原则上不参与策略逻辑
        bookfn;

        % 期权行情
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
        
        % 
        volsurf@VolSurface;
        
        % 现货行情, 50ETF
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
           % 逐一把m2tkCallOne和m2tkPutOne中设置新的counter
           % 思考：OptionOne是handle子类，这里的修改会给所有人带来影响！！
           % 暂时只用一个counter进行做市交易，没大碍，以后一定要改
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

