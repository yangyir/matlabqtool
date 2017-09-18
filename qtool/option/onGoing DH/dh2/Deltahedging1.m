classdef Deltahedging1 <handle
    
    properties(Hidden = false)       
        
        
        freq = [];
        total_val = [];
        invest_frac = 10000;
        num_option_lot = 1;  % ������Ȩ��������ʼ�ճ�����ô�ࣩ
        cash = 0;
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
  
        prime_rate  = 0.05;
        mature_time = '2016-03-25';
        year2mature = [];
        strike      = 2.20;
        option_type = 'call';
        option_multiplier = 10000;
    end
         
        % �˻���Ϣ, ��ʼ�����ٸĶ�
    properties(SetAccess = 'private', Hidden = true )
   
        accountCode = '202006';
        combiNo     = '820002006-J';
        marketNo    = '1';         %�����г�
        stockCode   = '510050';   %֤ȯ����        
        token       = [];
        connection  = [];
        heartbeatTimer = [];
        
    end
        
        
        
        
    %% �µ���غ�����  OMS�� EMS    
    methods
    
        % �µ�
        function self = openfire(self)
            
            connection = self.connection;
            token = self.token;
            accountCode = self.accountCode;
            combiNo = self.combiNo;
            
            marketNo = self.marketNo;
            stockCode = self.stockCode;            
            
            
            % openfire here
            
    
            % entrustPrice
            entrustPrice = self.current_underling_price;
            
            
            % entrustAmount, entrustDirection
            aimHoldingQ     = self.current_delta * self.option_multiplier * self.num_option_lot;
            entrustAmount   = aimHoldingQ - self.current_holding_q ;
            
            if entrustAmount > 0
                entrustDirection = '1';
            elseif entrustAmount < 0
                entrustDirection = '2';
            else
                entrustDirection = '0';
            end
            
            entrustAmount = round( abs(entrustAmount) / 100 ) * 100;
            
            
            % ��һ������
            entrustValue  = entrustAmount * entrustPrice;
            if entrustValue > self.cash
                warning('����ʧ�ܣ��˻��ʽ������µ����');
                return;
            end
            
           %% entrustAmount
            if entrustAmount >= 100
            
                [errorCode,errorMsg,entrustNo] = Entrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount);
                if errorCode == 0
                    disp('ί�гɹ�');
                    
                    % TODO: ��ѯ����״̬�� ���б�Ҫ�������� ���߳����� ֱ��һ��������ȫ������
                    
                    
                    %���²���¼
                    % TODO: ��¼Ӧ��ÿ���غ϶����������������µ�����
                    % TODO����ʹ�µ�������¼��ҲҪ�ȵ�����ȫ�˽��
                    self.past_delta = self.current_delta;
                    
                    fee = entrustPrice*entrustAmount*self.trading_cost;
                    self.BS_option_price();
                    temp_rec = [now,entrustPrice,entrustAmount,fee,self.theoretical_price];
                    self.trading_record = [self.trading_record;temp_rec];
                    
                else
                    disp(['�µ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%                     Logout(connection,token);
                    return;
                end
            
            end
        
        end
        
        % delta�ļ�����option_type�޹�
        function self = cal_delta(self)
            
            K = self.strike;
            T = self.year2mature;
            S = self.current_underling_price;
            r = self.prime_rate;
            sigma = self.est_vol;
            
            
            d1 = (log(S/K) + (r+sigma^2/2)*T)/(sigma*sqrt(T));
            self.current_delta = normcdf(d1);
            
%           self.current_delta = blsdelta( S, K, r, T, sigma, 0);

        end
        
        function self = BS_option_price(self)
            
            K = self.strike;
            T = self.year2mature;
            S = self.current_underling_price;
            r = self.prime_rate;
            sigma = self.est_vol;
            
%             
%             d1 = (log(S/K) + (r+sigma^2/2)*T)/(sigma*sqrt(T));
%             d2 = d1 - sigma*sqrt(T);
%             self.theoretical_price = S*normcdf(d1)-K*exp(-r*T)*normcdf(d2);

            [c,p] = blsprice(S, K, r, T, sigma, 0);
            switch self.option_type
                case {'call', 'c', 'C', 'Call'}
                    self.theoretical_price = c;
                case {'put', 'Put', 'p', 'P'}
                    self.theoretical_price = p;
            end

        end        
        
        
        
    end
      
    
    %% ��ʼ����logout�ĺ���
    methods
        
        % ��object��Ĭ��ֵ
        function self = init_option_setting(self, R, K, T, est_vol, option_type)
            if exist('option_type', 'var'), self.option_type = option_type; end
            if exist('R', 'var'),           self.prime_rate = R;            end
            if exist('est_vol', 'var'),     self.est_vol   = est_vol;       end
            if exist('K', 'var'),           self.strike     = K;            end
            if exist('T', 'var'),           self.mature_time = T;           end
            self.year2mature = (datenum(self.mature_time)-round(now))/365;
            
            
            self.cal_delta;
            self.past_delta = self.current_delta; % ����ȥ��
        end
            
        
        % Ĭ�ϵ�½���ã������ӡ���½������,
        % TODO: δ���
        function self = init_trading_setting(self,serverIp, serverPort, operatorNo, password, accountCode, combiNo)
            
            serverIp    = '192.168.41.72';
            serverPort  = 9003;
            operatorNo  = '2038';
            password    = '1';
            accountCode = '2016';
            combiNo     = '82000016-J';
            
            javaaddpath('.\UFXdemo_MATLAB\ESBJavaAPI.jar');
            
%             marketNo = '1';         %�����г�
%             stockCode = '510050';   %֤ȯ����

            
            %����
            [errorCode, errorMsg, connection] = Connect(serverIp,serverPort);
            if errorCode < 0
                disp(['���ӷ�����ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
                disp('���ӳɹ�');
                self.connection = connection;
            end
            
            
            %��¼
            [errorCode,errorMsg,token] = Login(connection,operatorNo,password);
            if errorCode < 0
                disp(['��¼ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
                disp('��¼�ɹ�');
                self.token = token;
            end
            
            %����������tokenһֱ����
            self.heartbeatTimer = HeartBeat(connection,token);
               
            
        end
        
         %%  ����ʵ��.  Ĭ�ϵ�½���ã������ӡ���½������
        function self = init_real_account_setting(self)
            
            serverIp    = '10.42.28.148';
            serverPort  = 9003;
            operatorNo  = '2038';
            password    = '1';
%                accountCode = '2016';
%                combiNo     = '82000016-J'

            accountCode = '202006';
            combiNo     = '820002006-J';
            
            
            
            self.accountCode = accountCode;
            self.combiNo    = combiNo;
            self.marketNo   = '1';
            self.stockCode  = '510050';   %֤ȯ����
            
            
            javaaddpath('.\UFXdemo_MATLAB\ESBJavaAPI.jar');
            

            
            %���� 
            [errorCode, errorMsg, connection] = Connect(serverIp,serverPort);
            if errorCode < 0
                disp(['���ӷ�����ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
                disp('���ӳɹ�');
                self.connection = connection;
            end
            
            
            %��¼
            [errorCode,errorMsg,token] = Login(connection,operatorNo,password);
            if errorCode < 0
                disp(['��¼ʧ�ܡ�������ϢΪ:',errorMsg]);
                return;
            else
                disp('��¼�ɹ�');
                self.token = token;
            end
            
            %����������tokenһֱ����
            self.heartbeatTimer = HeartBeat(connection,token);               
            
        end
        
        
        function self = logout(self)
                %�˳���¼
            Logout(self.connection, self.token);
            delete(self.heartbeatTimer);
        end
        
        
        
        
    end
    
    
    
    %% ȡ��������״̬�ĺ����� QMS��PMS
    methods
        %% ȡS�ĵ�ǰ�۸�
        function self = get_current_price(self)
            connection = self.connection;
            token = self.token;
            accountCode = self.accountCode;
            combiNo = self.combiNo;
            
            marketNo = self.marketNo;
            stockCode = self.stockCode;
            
            [errorCode,errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode);
            % TODO: ��ô���������
%             -------------��óֲ���Ϣ--------------
%             [0]ErrorCode	[1]ErrorMsg	[2]MsgDetail	[3]DataCount
%             [0]0	[1]	[2]	[3]0
            
            if errorCode < 0
                disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%                 Logout(connection,token);
%                 delete(heartbeatTimer);
                return;
            else
                disp('-------------��óֲ���Ϣ--------------');
                PrintPacket2(packet); %��ӡ�ֲ���Ϣ
            end
            
            self.current_underling_price = packet.getDoubleByIndex(14);
            packet.getDoubleByIndex(14)
        end
        
        
        function [] = myDemo()
            
            
        end
        
        
        
        
        % ������ϵ�״̬�� 50etf�ֲֺ��ֽ�
        function [] = update_portfolio(self)
            connection = self.connection;
            token       = self.token;
            accountCode = self.accountCode;
            combiNo     = self.combiNo;
            marketNo    = self.marketNo;
            stockCode   = '510050';
            
            %��ѯ�ʽ�
            [errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);
            if errorCode < 0
                disp(['���ʽ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%                 Logout(connection,token);
%                 delete(heartbeatTimer);
                return;
            else
%                 disp('-------------�ʽ���Ϣ--------------');
%                 PrintPacket2(packet); %��ӡ�ʽ���Ϣ
                self.cash =  packet.getDoubleByIndex(3);
            end
            
            
            %��ѯ510050�ֲ�
            [errorCode,errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode);
            if errorCode < 0
                disp(['��ֲ�ʧ�ܡ�������ϢΪ:',errorMsg]);
%                 Logout(connection,token);
%                 delete(heartbeatTimer);
                return;
            else
%                 disp('-------------�ֲ���Ϣ--------------');
%                 PrintPacket2(packet); %��ӡ�ֲ���Ϣ
                self.current_holding_q = packet.getDoubleByIndex(10);
            end
        end
        
    end
    
    
    

    
    
    
end