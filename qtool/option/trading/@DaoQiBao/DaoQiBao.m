classdef DaoQiBao < handle
    %DAOQIBAO 到期宝策略
    
     % 策略必须有的公共量
    properties(SetAccess = 'public', Hidden = true ) % 调试的时候public，为了方便
         % 账户信息, 初始化后不再改动
        counter@CounterHSO32;       % O32柜台
        book@Book   = Book;         % 投资组合信息，只负责记录清楚就行了，原则上不参与策略逻辑
        
        % 期权行情
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
    end
    
    %　主要用于研究
    properties
        
        bookfn    =  'D:\intern\5.吴云峰\optionStraddleTrading\Book_daoqibao.xlsx';
        optinfofn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
        
        today;  % 今日日期
        T1;     % 最近到期日
        
        m2tkCallExpPayoff@M2TK;  % 基于payoff的看涨M2TK
        m2tkPutExpPayoff@M2TK;   % 基于payoff的看跌M2TK
        
        tradingNum; % 未来的交易日的数目
        distST;     % 未来的ST的分布
        
    end
    
    
    %% 交易用的函数
    methods
        function init_all(stra)
            %% 初始化：给strat挂上counter， book， quote
            % counter 用默认值
            c = CounterHSO32.hequn2038_2034_opt;
            c.login;
            c.printInfo;
            stra.counter = c;
            
            
            % 读取昨日的book
            stra.bookfn = 'D:\intern\5.吴云峰\optionStraddleTrading\Book_daoqibao.xlsx';
%             bookfn = stra.bookfn;
            b = Book;
            try 
                b.fromExcel(stra.bookfn);
            catch e
                % 如果不存在这本book，就新建
            end
            stra.book = b;
            
            
            % 生成所有的quoteOpt，并用M2TK挂上
            stra.optinfofn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
            [q, m2c, m2p] =  QuoteOpt.init_from_sse_excel( stra.optinfofn );
            stra.quote          = q;
            stra.m2tkCallQuote  = m2c;
            stra.m2tkPutQuote   = m2p;
            
            
            % 启动H5行情
            % 打开H5行情，必须在counter连接初始化后
            pause(3)
            mktlogin
            pause(3)
            while 1
                [p, mat] = getCurrentPrice('510050', '1');
                % getCurrentPrice('510050', '1');
                % getCurrentPrice('10000346', '3');
                if p(1) > 0
                    break;
                else
                    disp('行情有问题');
                    pause(1)
                end
            end          
            
        end
        
        % 日末，关闭策略
        function end_day(obj)
            obj.counter.logout;
            obj.book.toExcel(obj.bookfn);
        end
        
        
        function openfire(obj)
            
            % 计算一个K上的bid，margin，低于/高于概率
            
            
            
            % TODO：要做一个最优化的structure
            % 目标函数1： 收益预期最大的合约
            % 目标函数2： 收益率预期最大（考虑margin占用）
            
            
            
        end
    end
    
    
    %% 研究用的函数
    methods
        function [ obj ] = hist_dist_ST(obj, S0 )
            % S0是当前的50ETF的价格
            if ~exist( 'S0' , 'var' )
                S0 = obj.m2tkCallQuote.data(1,1).S;
            end
            
            obj.today = today;
            
            % 首先获取到期的日期( 最近的到期的日期是在第一行的情形 )
            obj.T1 = obj.m2tkCallQuote.data(1,1).T;
            % 因此这是用于计算的日期的数目
            tradingNum = obj.tradingNum;            
            % 获取S历史数据， （历史数据可以存成一个固定文件）
            load HistoryPrice50ETF
            L = length( historyPrice50ETF );
            % 计算收益率
            ret50ETF = ( historyPrice50ETF( tradingNum+1:L ) - ...
                historyPrice50ETF( 1:L - tradingNum ) )./historyPrice50ETF( 1:L - tradingNum );
            % 根据历史数据得到ST的分布
            % 根据obj.Today 和 obj.T1 和当前S0， 估算ST可能值
            ST = ( 1 + ret50ETF )*S0;
            obj.distST = ST;
            
        end
        
        function [ m2cProb, m2pProb ] = ST_reach_K_prob( obj , S0 )
            % 计算ST到达K的概率， 即K点上的百分位数
            % 输出是两个M2TK
            
            if ~exist( 'S0' , 'var' )
                S0 = obj.m2tkCallQuote.data(1,1).S;
            end
            
            % 首先获取ST的情形
            [ obj ] = obj.hist_dist_ST( S0 );
            ST = obj.distST;
            
            % 基于K再获取两个概率
            xPropsCall = obj.m2tkCallQuote.xProps;
            xPropsPut  = obj.m2tkPutQuote.xProps;
            
            L     = length( ST );
            callL = length( xPropsCall );
            putL  = length( xPropsPut );
            callProb = nan( 1 , callL );
            putProb  = nan( 1 , putL );
            
            % 计算call的prob
            for i = 1:callL
                K = xPropsCall( i );
                callProb( i ) = sum( ST >= K )/L;
            end
            
            % 计算put的prob
            for i = 1:putL
                K = xPropsPut( i );
                putProb( i ) = sum( ST <= K )/L;
            end
            
            % 复制
            m2cProb = obj.m2tkCallQuote.getCopy;
            m2pProb = obj.m2tkPutQuote.getCopy;
            % 数据赋予
            m2cProb.data = callProb;
            m2pProb.data = putProb;
            
        end
            

        function [ m2cPayoff, m2pPayoff ] = exp_payoff( obj, distST )
            % 算T1期期权的预期收益
            % 输出量是M2TK类型，存在obj里
            if ~exist( 'distST' , 'var' )
                obj.hist_dist_ST;
                distST = obj.distST;
            end
            
            xPropsCall = obj.m2tkCallQuote.xProps;
            xPropsPut  = obj.m2tkPutQuote.xProps;
            callL = length( xPropsCall );
            putL  = length( xPropsPut );
            
            % 对于每一个期权（K）， 算 optinfo.calc_payoff( ST )，然后求均值
            callPayoff = nan( 1 , callL );
            putPayoff  = nan( 1 , putL );
            % 看涨期权的期望payoff的计算
            for i = 1:callL
                if ~strcmp( obj.m2tkCallQuote.data(1,i).optName , '无名期权' )
                    obj.m2tkCallQuote.data(1,i).ST = distST;
                    callPayoff( i ) = nanmean( obj.m2tkCallQuote.data(1,i).calcPayoff );
                end
            end
            % 看跌期权的payoff的计算
            for i = 1:putL
                if ~strcmp( obj.m2tkPutQuote.data(1,i).optName , '无名期权' )
                    obj.m2tkPutQuote.data(1,i).ST = distST;
                    putPayoff( i ) = nanmean( obj.m2tkPutQuote.data(1,i).calcPayoff );
                end
            end
            
            m2cPayoff = obj.m2tkCallQuote.getCopy;
            m2pPayoff = obj.m2tkPutQuote.getCopy;
            m2cPayoff.data = callPayoff;
            m2pPayoff.data = putPayoff;

        end
        
        
        function [ callExport , putExport ] = display_oppotunity( obj )
            % 分call和put输出
            % 一行：K
            % 一行：到达概率
            % 一行：预期payoff（成本）
            % 一行：目前bid价（收入）
            % 一行：净收益额 = 收入 - 成本
            % 一行：资金占用（margin）
            % 一行：净收益率 = 净收益额 / 资金占用
            % 一行：最大收益率 = 收入 / 资金占用
            
            format compact
            % K值
            callK = obj.m2tkCallQuote.xProps;
            putK  = obj.m2tkPutQuote.xProps;
            callLength = length( callK );
            putLength  = length( putK );
            
            % 到达的概率
            [ m2cProb, m2pProb ] = obj.ST_reach_K_prob;
            callProb = m2cProb.data;
            putProb  = m2pProb.data;
            
            % 计算预期的payoff
            [ m2cPayoff, m2pPayoff ] = obj.exp_payoff;
            callPayoff = m2cPayoff.data;
            putPayoff  = m2pPayoff.data;
            
            % 获取目前的bid价格
            callBid = nan( 1 , callLength );
            putBid  = nan( 1 , putLength );
            for i = 1:callLength
                if ~strcmp( obj.m2tkCallQuote.data(1,i).optName , '无名期权' )
                    callBid( i ) = obj.m2tkCallQuote.data( 1 , i ).bidP1;
                end
            end
            for i = 1:putLength
                if ~strcmp( obj.m2tkPutQuote.data(1,i).optName , '无名期权' )
                    putBid( i )  = obj.m2tkPutQuote.data( 1 , i ).bidP1;
                end
            end
            
            % 获取净收益额
            callRetrn = callBid - callPayoff;
            putRetrn  = putBid - putPayoff;
            
            % 获取资金的占用
            callMg = nan( 1 , callLength );
            putMg  = nan( 1 , putLength );
            for i = 1:callLength
                if ~strcmp( obj.m2tkCallQuote.data(1,i).optName , '无名期权' )
                    callMg(i) = obj.m2tkCallQuote.data( 1 , i ).margin;
                end
            end
            for i = 1:putLength
                if ~strcmp( obj.m2tkPutQuote.data(1,i).optName , '无名期权' )
                    putMg(i)  = obj.m2tkPutQuote.data( 1 , i ).margin;
                end
            end
            
            % 获取净收益率
            callRetrnRate = callRetrn./callMg;
            putRetrnRate  = putRetrn./putMg;
            
            % 最大收益率
            callMaxRetrnRate = callBid./callMg;
            putMaxRetrnRate  = putBid./putMg;
            
            % 将结果进行总结
            list = { 'K';'到达概率';'预期payoff（成本）';'目前bid价（收入）';'净收益额 = 收入 - 成本';...
                '资金占用（margin）';'净收益率 = 净收益额 / 资金占用';'最大收益率 = 收入 / 资金占用' };
            callExport = num2cell( [ callK ; callProb ; callPayoff ; callBid ; ...
                callRetrn ; callMg ; callRetrnRate ; callMaxRetrnRate ] );
            putExport  = num2cell( [ putK ; putProb ; putPayoff ; putBid ; ...
                putRetrn ; putMg ; putRetrnRate ; putMaxRetrnRate ] );
            callExport = [ list callExport ];
            putExport  = [ list putExport ];
            
        end
        
        
        
    end
    
    
end

