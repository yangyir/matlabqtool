classdef Deltahedging2 <handle
    
    properties(Hidden = false)       
        book@Book = Book;  % Ͷ�������Ϣ��ֻ�����¼��������ˣ�ԭ���ϲ���������߼�
        
        
        freq = [];
        total_val = [];
        invest_frac = 10000;
        num_option_lot = 1;  % ������Ȩ��������ʼ�ճ�����ô�ࣩ
        cash = 0;
        
        
        % ������Ϣ
        vol = [];
        imp_vol = [];
        est_vol = 0.25;
        
       
        
        
        % �г���Ϣ����ʱ����
        current_underling_price = [];
        current_time = [];       
        theoretical_price = [];
        
        
        past_delta = 0;
        current_delta = [];
        
        current_holding_q = 0;
        
        
        trading_cost = 0.0008;
        trading_record = [];
        
        
        
    end
    
    
    % ��Ȩ��Ϣ����ʼ����������ٸĶ�
    properties(SetAccess = 'private', Hidden = false)
        option_multiplier = 10000;
        optPricer = OptPricer;
    end
         
    % �˻���Ϣ, ��ʼ�����ٸĶ�
    properties(SetAccess = 'private', Hidden = true )
        counter     = CounterHSO32;  % O32��̨
        marketNo    = '1';         %�����г�
        stockCode   = '510050';   %֤ȯ����        
    end
        
        
        
        
    %% �µ���غ�����  OMS�� EMS    
    methods
        [self] = openfire(self)
        
        % delta�ļ���
        function self = cal_delta(self)
            op = self.optPricer;
            op.S = self.current_underling_price;
            self.current_delta = op.calcDelta;
        end
        
        function self = BS_option_price(self)            
            self.theoretical_price = self.optPricer.calcPx();
         end        
    end
      
    
    %% ��ʼ����logout�ĺ���
    methods
        
        % optionĬ��ֵ
        function self = init_option_setting(self, R, K, T, est_vol, option_type)
            op = OptPricer;
            self.optPricer = op;
            if exist('option_type', 'var'), op.CP   = option_type; end
            if exist('R', 'var'),           op.r    = R;            end
            if exist('est_vol', 'var'),     op.sigma= est_vol;       end
            if exist('K', 'var'),           op.K    = K;            end
            if exist('T', 'var'),           op.T    = T;           end
            op.currentDate = today;
            op.calcTau
            op.S = self.current_underling_price;
            self.current_delta = op.calcDelta;
                        
            self.past_delta = self.current_delta; % ����ȥ��
        end
            
        
        
        
         %%  ����ʵ��.  Ĭ�ϵ�½���ã������ӡ���½������
        function self = init_real_account_setting(self)
            
            serverIp    = '10.42.28.148';
            serverPort  = 9003;
            operatorNo  = '2038';
            password    = '111aaa';
%                accountCode = '2016';
%                combiNo     = '82000016-J'
            accountCode = '202006';
            combiNo     = '820002006-J';
            
            c = CounterHSO32(serverIp,serverPort, operatorNo, password, accountCode, combiNo);
            self.counter = c;            
            c.login;
            
            self.marketNo   = '1';
            self.stockCode  = '510050';   %֤ȯ����    
            
        end
        
        
        function self = logout(self)
                %�˳���¼
            self.counter.logout;
        end
        
        
        
        
    end
    
    
    
    %% ȡ��������״̬�ĺ����� QMS��PMS
    methods
        %% ȡS�ĵ�ǰ�۸�
        function [px] = get_current_price(self)
            marketNo = self.marketNo;
            stockCode = self.stockCode;
            
            [errorCode,errorMsg,packet] = self.counter.queryCombiStock(marketNo,stockCode);
%             -------------��óֲ���Ϣ--------------
%             [0]ErrorCode	[1]ErrorMsg	[2]MsgDetail	[3]DataCount
%             [0]0	[1]	[2]	[3]0
            
            if errorCode < 0
                disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
%                 disp('-------------��óֲ���Ϣ--------------');
%                 PrintPacket2(packet); %��ӡ�ֲ���Ϣ
            end
            px = packet.getDoubleByIndex(16);
            self.current_underling_price = px;
            self.optPricer.S = px;
        end
        
         % ������ϵ�״̬�� 50etf�ֲֺ��ֽ�
        function [] = update_portfolio(self)
            marketNo    = self.marketNo;
            stockCode   = '510050';
            
            %��ѯ�ʽ�
            [errorCode,errorMsg,packet] = self.counter.queryAccount();
            if errorCode < 0
                disp(['���ʽ�ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
%                 disp('-------------�ʽ���Ϣ--------------');
%                 PrintPacket2(packet); %��ӡ�ʽ���Ϣ
                self.cash =  packet.getDoubleByIndex(3);
            end
            
            
            %��ѯ510050�ֲ�
            [errorCode,errorMsg,packet] = self.counter.queryCombiStock(marketNo,stockCode);
            if errorCode < 0
                disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
%                 disp('-------------�ֲ���Ϣ--------------');
%                 PrintPacket2(packet); %��ӡ�ֲ���Ϣ
                self.current_holding_q = packet.getDoubleByIndex(10);
            end
        end
        
    end
    
    
    

    
    
    
end