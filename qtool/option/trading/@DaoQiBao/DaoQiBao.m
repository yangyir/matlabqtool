classdef DaoQiBao < handle
    %DAOQIBAO ���ڱ�����
    
     % ���Ա����еĹ�����
    properties(SetAccess = 'public', Hidden = true ) % ���Ե�ʱ��public��Ϊ�˷���
         % �˻���Ϣ, ��ʼ�����ٸĶ�
        counter@CounterHSO32;       % O32��̨
        book@Book   = Book;         % Ͷ�������Ϣ��ֻ�����¼��������ˣ�ԭ���ϲ���������߼�
        
        % ��Ȩ����
        quote;
        m2tkCallQuote@M2TK;
        m2tkPutQuote@M2TK;
    end
    
    %����Ҫ�����о�
    properties
        
        bookfn    =  'D:\intern\5.���Ʒ�\optionStraddleTrading\Book_daoqibao.xlsx';
        optinfofn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
        
        today;  % ��������
        T1;     % ���������
        
        m2tkCallExpPayoff@M2TK;  % ����payoff�Ŀ���M2TK
        m2tkPutExpPayoff@M2TK;   % ����payoff�Ŀ���M2TK
        
        tradingNum; % δ���Ľ����յ���Ŀ
        distST;     % δ����ST�ķֲ�
        
    end
    
    
    %% �����õĺ���
    methods
        function init_all(stra)
            %% ��ʼ������strat����counter�� book�� quote
            % counter ��Ĭ��ֵ
            c = CounterHSO32.hequn2038_2034_opt;
            c.login;
            c.printInfo;
            stra.counter = c;
            
            
            % ��ȡ���յ�book
            stra.bookfn = 'D:\intern\5.���Ʒ�\optionStraddleTrading\Book_daoqibao.xlsx';
%             bookfn = stra.bookfn;
            b = Book;
            try 
                b.fromExcel(stra.bookfn);
            catch e
                % ����������Ȿbook�����½�
            end
            stra.book = b;
            
            
            % �������е�quoteOpt������M2TK����
            stra.optinfofn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
            [q, m2c, m2p] =  QuoteOpt.init_from_sse_excel( stra.optinfofn );
            stra.quote          = q;
            stra.m2tkCallQuote  = m2c;
            stra.m2tkPutQuote   = m2p;
            
            
            % ����H5����
            % ��H5���飬������counter���ӳ�ʼ����
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
                    disp('����������');
                    pause(1)
                end
            end          
            
        end
        
        % ��ĩ���رղ���
        function end_day(obj)
            obj.counter.logout;
            obj.book.toExcel(obj.bookfn);
        end
        
        
        function openfire(obj)
            
            % ����һ��K�ϵ�bid��margin������/���ڸ���
            
            
            
            % TODO��Ҫ��һ�����Ż���structure
            % Ŀ�꺯��1�� ����Ԥ�����ĺ�Լ
            % Ŀ�꺯��2�� ������Ԥ����󣨿���marginռ�ã�
            
            
            
        end
    end
    
    
    %% �о��õĺ���
    methods
        function [ obj ] = hist_dist_ST(obj, S0 )
            % S0�ǵ�ǰ��50ETF�ļ۸�
            if ~exist( 'S0' , 'var' )
                S0 = obj.m2tkCallQuote.data(1,1).S;
            end
            
            obj.today = today;
            
            % ���Ȼ�ȡ���ڵ�����( ����ĵ��ڵ��������ڵ�һ�е����� )
            obj.T1 = obj.m2tkCallQuote.data(1,1).T;
            % ����������ڼ�������ڵ���Ŀ
            tradingNum = obj.tradingNum;            
            % ��ȡS��ʷ���ݣ� ����ʷ���ݿ��Դ��һ���̶��ļ���
            load HistoryPrice50ETF
            L = length( historyPrice50ETF );
            % ����������
            ret50ETF = ( historyPrice50ETF( tradingNum+1:L ) - ...
                historyPrice50ETF( 1:L - tradingNum ) )./historyPrice50ETF( 1:L - tradingNum );
            % ������ʷ���ݵõ�ST�ķֲ�
            % ����obj.Today �� obj.T1 �͵�ǰS0�� ����ST����ֵ
            ST = ( 1 + ret50ETF )*S0;
            obj.distST = ST;
            
        end
        
        function [ m2cProb, m2pProb ] = ST_reach_K_prob( obj , S0 )
            % ����ST����K�ĸ��ʣ� ��K���ϵİٷ�λ��
            % ���������M2TK
            
            if ~exist( 'S0' , 'var' )
                S0 = obj.m2tkCallQuote.data(1,1).S;
            end
            
            % ���Ȼ�ȡST������
            [ obj ] = obj.hist_dist_ST( S0 );
            ST = obj.distST;
            
            % ����K�ٻ�ȡ��������
            xPropsCall = obj.m2tkCallQuote.xProps;
            xPropsPut  = obj.m2tkPutQuote.xProps;
            
            L     = length( ST );
            callL = length( xPropsCall );
            putL  = length( xPropsPut );
            callProb = nan( 1 , callL );
            putProb  = nan( 1 , putL );
            
            % ����call��prob
            for i = 1:callL
                K = xPropsCall( i );
                callProb( i ) = sum( ST >= K )/L;
            end
            
            % ����put��prob
            for i = 1:putL
                K = xPropsPut( i );
                putProb( i ) = sum( ST <= K )/L;
            end
            
            % ����
            m2cProb = obj.m2tkCallQuote.getCopy;
            m2pProb = obj.m2tkPutQuote.getCopy;
            % ���ݸ���
            m2cProb.data = callProb;
            m2pProb.data = putProb;
            
        end
            

        function [ m2cPayoff, m2pPayoff ] = exp_payoff( obj, distST )
            % ��T1����Ȩ��Ԥ������
            % �������M2TK���ͣ�����obj��
            if ~exist( 'distST' , 'var' )
                obj.hist_dist_ST;
                distST = obj.distST;
            end
            
            xPropsCall = obj.m2tkCallQuote.xProps;
            xPropsPut  = obj.m2tkPutQuote.xProps;
            callL = length( xPropsCall );
            putL  = length( xPropsPut );
            
            % ����ÿһ����Ȩ��K���� �� optinfo.calc_payoff( ST )��Ȼ�����ֵ
            callPayoff = nan( 1 , callL );
            putPayoff  = nan( 1 , putL );
            % ������Ȩ������payoff�ļ���
            for i = 1:callL
                if ~strcmp( obj.m2tkCallQuote.data(1,i).optName , '������Ȩ' )
                    obj.m2tkCallQuote.data(1,i).ST = distST;
                    callPayoff( i ) = nanmean( obj.m2tkCallQuote.data(1,i).calcPayoff );
                end
            end
            % ������Ȩ��payoff�ļ���
            for i = 1:putL
                if ~strcmp( obj.m2tkPutQuote.data(1,i).optName , '������Ȩ' )
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
            % ��call��put���
            % һ�У�K
            % һ�У��������
            % һ�У�Ԥ��payoff���ɱ���
            % һ�У�Ŀǰbid�ۣ����룩
            % һ�У�������� = ���� - �ɱ�
            % һ�У��ʽ�ռ�ã�margin��
            % һ�У��������� = ������� / �ʽ�ռ��
            % һ�У���������� = ���� / �ʽ�ռ��
            
            format compact
            % Kֵ
            callK = obj.m2tkCallQuote.xProps;
            putK  = obj.m2tkPutQuote.xProps;
            callLength = length( callK );
            putLength  = length( putK );
            
            % ����ĸ���
            [ m2cProb, m2pProb ] = obj.ST_reach_K_prob;
            callProb = m2cProb.data;
            putProb  = m2pProb.data;
            
            % ����Ԥ�ڵ�payoff
            [ m2cPayoff, m2pPayoff ] = obj.exp_payoff;
            callPayoff = m2cPayoff.data;
            putPayoff  = m2pPayoff.data;
            
            % ��ȡĿǰ��bid�۸�
            callBid = nan( 1 , callLength );
            putBid  = nan( 1 , putLength );
            for i = 1:callLength
                if ~strcmp( obj.m2tkCallQuote.data(1,i).optName , '������Ȩ' )
                    callBid( i ) = obj.m2tkCallQuote.data( 1 , i ).bidP1;
                end
            end
            for i = 1:putLength
                if ~strcmp( obj.m2tkPutQuote.data(1,i).optName , '������Ȩ' )
                    putBid( i )  = obj.m2tkPutQuote.data( 1 , i ).bidP1;
                end
            end
            
            % ��ȡ�������
            callRetrn = callBid - callPayoff;
            putRetrn  = putBid - putPayoff;
            
            % ��ȡ�ʽ��ռ��
            callMg = nan( 1 , callLength );
            putMg  = nan( 1 , putLength );
            for i = 1:callLength
                if ~strcmp( obj.m2tkCallQuote.data(1,i).optName , '������Ȩ' )
                    callMg(i) = obj.m2tkCallQuote.data( 1 , i ).margin;
                end
            end
            for i = 1:putLength
                if ~strcmp( obj.m2tkPutQuote.data(1,i).optName , '������Ȩ' )
                    putMg(i)  = obj.m2tkPutQuote.data( 1 , i ).margin;
                end
            end
            
            % ��ȡ��������
            callRetrnRate = callRetrn./callMg;
            putRetrnRate  = putRetrn./putMg;
            
            % ���������
            callMaxRetrnRate = callBid./callMg;
            putMaxRetrnRate  = putBid./putMg;
            
            % ����������ܽ�
            list = { 'K';'�������';'Ԥ��payoff���ɱ���';'Ŀǰbid�ۣ����룩';'������� = ���� - �ɱ�';...
                '�ʽ�ռ�ã�margin��';'�������� = ������� / �ʽ�ռ��';'��������� = ���� / �ʽ�ռ��' };
            callExport = num2cell( [ callK ; callProb ; callPayoff ; callBid ; ...
                callRetrn ; callMg ; callRetrnRate ; callMaxRetrnRate ] );
            putExport  = num2cell( [ putK ; putProb ; putPayoff ; putBid ; ...
                putRetrn ; putMg ; putRetrnRate ; putMaxRetrnRate ] );
            callExport = [ list callExport ];
            putExport  = [ list putExport ];
            
        end
        
        
        
    end
    
    
end

