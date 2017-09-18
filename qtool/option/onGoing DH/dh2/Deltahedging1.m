classdef Deltahedging1 <handle
    
    properties(Hidden = false)       
        
        
        freq = [];
        total_val = [];
        invest_frac = 10000;
        num_option_lot = 1;  % 持有期权的手数（始终持有这么多）
        cash = 0;
        vol = [];
        imp_vol = [];
        est_vol = 0.25;
        
       
        
        
        % 市场信息，定时更新
        current_underling_price = [];
        current_time = [];       
        theoretical_price = [];
        
        
        past_delta = 0;
        current_delta = [];
        
        current_holding_q = 0;
        
        
        trading_cost = 0.0008;
        trading_record = [];
        
        
    end
    
    
          % 期权信息，初始化后基本不再改动
    properties(SetAccess = 'private', Hidden = false)
  
        prime_rate  = 0.05;
        mature_time = '2016-03-25';
        year2mature = [];
        strike      = 2.20;
        option_type = 'call';
        option_multiplier = 10000;
    end
         
        % 账户信息, 初始化后不再改动
    properties(SetAccess = 'private', Hidden = true )
   
        accountCode = '202006';
        combiNo     = '820002006-J';
        marketNo    = '1';         %交易市场
        stockCode   = '510050';   %证券代码        
        token       = [];
        connection  = [];
        heartbeatTimer = [];
        
    end
        
        
        
        
    %% 下单相关函数，  OMS， EMS    
    methods
    
        % 下单
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
            
            
            % 做一次验资
            entrustValue  = entrustAmount * entrustPrice;
            if entrustValue > self.cash
                warning('验资失败：账户资金少于下单金额');
                return;
            end
            
           %% entrustAmount
            if entrustAmount >= 100
            
                [errorCode,errorMsg,entrustNo] = Entrust(connection,token,combiNo,marketNo,stockCode,entrustDirection,entrustPrice,entrustAmount);
                if errorCode == 0
                    disp('委托成功');
                    
                    % TODO: 查询订单状态， 如有必要，补单， 或者撤单， 直至一个订单完全处理完
                    
                    
                    %更新并记录
                    % TODO: 记录应该每个回合都做，而不仅仅是下单才做
                    % TODO：即使下单才做记录，也要等单子完全了结后
                    self.past_delta = self.current_delta;
                    
                    fee = entrustPrice*entrustAmount*self.trading_cost;
                    self.BS_option_price();
                    temp_rec = [now,entrustPrice,entrustAmount,fee,self.theoretical_price];
                    self.trading_record = [self.trading_record;temp_rec];
                    
                else
                    disp(['下单失败。错误信息为:',errorMsg]);
%                     Logout(connection,token);
                    return;
                end
            
            end
        
        end
        
        % delta的计算与option_type无关
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
      
    
    %% 初始化和logout的函数
    methods
        
        % 新object的默认值
        function self = init_option_setting(self, R, K, T, est_vol, option_type)
            if exist('option_type', 'var'), self.option_type = option_type; end
            if exist('R', 'var'),           self.prime_rate = R;            end
            if exist('est_vol', 'var'),     self.est_vol   = est_vol;       end
            if exist('K', 'var'),           self.strike     = K;            end
            if exist('T', 'var'),           self.mature_time = T;           end
            self.year2mature = (datenum(self.mature_time)-round(now))/365;
            
            
            self.cal_delta;
            self.past_delta = self.current_delta; % 加上去的
        end
            
        
        % 默认登陆设置，并连接、登陆、心跳,
        % TODO: 未完成
        function self = init_trading_setting(self,serverIp, serverPort, operatorNo, password, accountCode, combiNo)
            
            serverIp    = '192.168.41.72';
            serverPort  = 9003;
            operatorNo  = '2038';
            password    = '1';
            accountCode = '2016';
            combiNo     = '82000016-J';
            
            javaaddpath('.\UFXdemo_MATLAB\ESBJavaAPI.jar');
            
%             marketNo = '1';         %交易市场
%             stockCode = '510050';   %证券代码

            
            %连接
            [errorCode, errorMsg, connection] = Connect(serverIp,serverPort);
            if errorCode < 0
                disp(['连接服务器失败。错误信息为:',errorMsg]);
                return;
            else
                disp('连接成功');
                self.connection = connection;
            end
            
            
            %登录
            [errorCode,errorMsg,token] = Login(connection,operatorNo,password);
            if errorCode < 0
                disp(['登录失败。错误信息为:',errorMsg]);
                return;
            else
                disp('登录成功');
                self.token = token;
            end
            
            %心跳。保持token一直可用
            self.heartbeatTimer = HeartBeat(connection,token);
               
            
        end
        
         %%  连接实盘.  默认登陆设置，并连接、登陆、心跳
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
            self.stockCode  = '510050';   %证券代码
            
            
            javaaddpath('.\UFXdemo_MATLAB\ESBJavaAPI.jar');
            

            
            %连接 
            [errorCode, errorMsg, connection] = Connect(serverIp,serverPort);
            if errorCode < 0
                disp(['连接服务器失败。错误信息为:',errorMsg]);
                return;
            else
                disp('连接成功');
                self.connection = connection;
            end
            
            
            %登录
            [errorCode,errorMsg,token] = Login(connection,operatorNo,password);
            if errorCode < 0
                disp(['登录失败。错误信息为:',errorMsg]);
                return;
            else
                disp('登录成功');
                self.token = token;
            end
            
            %心跳。保持token一直可用
            self.heartbeatTimer = HeartBeat(connection,token);               
            
        end
        
        
        function self = logout(self)
                %退出登录
            Logout(self.connection, self.token);
            delete(self.heartbeatTimer);
        end
        
        
        
        
    end
    
    
    
    %% 取行情和组合状态的函数， QMS，PMS
    methods
        %% 取S的当前价格
        function self = get_current_price(self)
            connection = self.connection;
            token = self.token;
            accountCode = self.accountCode;
            combiNo = self.combiNo;
            
            marketNo = self.marketNo;
            stockCode = self.stockCode;
            
            [errorCode,errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode);
            % TODO: 怎么处理这个？
%             -------------获得持仓信息--------------
%             [0]ErrorCode	[1]ErrorMsg	[2]MsgDetail	[3]DataCount
%             [0]0	[1]	[2]	[3]0
            
            if errorCode < 0
                disp(['查持仓失败。错误信息为:',errorMsg]);
%                 Logout(connection,token);
%                 delete(heartbeatTimer);
                return;
            else
                disp('-------------获得持仓信息--------------');
                PrintPacket2(packet); %打印持仓信息
            end
            
            self.current_underling_price = packet.getDoubleByIndex(14);
            packet.getDoubleByIndex(14)
        end
        
        
        function [] = myDemo()
            
            
        end
        
        
        
        
        % 更新组合的状态： 50etf持仓和现金
        function [] = update_portfolio(self)
            connection = self.connection;
            token       = self.token;
            accountCode = self.accountCode;
            combiNo     = self.combiNo;
            marketNo    = self.marketNo;
            stockCode   = '510050';
            
            %查询资金
            [errorCode,errorMsg,packet] = QueryAccount(connection,token,accountCode,combiNo);
            if errorCode < 0
                disp(['查资金失败。错误信息为:',errorMsg]);
%                 Logout(connection,token);
%                 delete(heartbeatTimer);
                return;
            else
%                 disp('-------------资金信息--------------');
%                 PrintPacket2(packet); %打印资金信息
                self.cash =  packet.getDoubleByIndex(3);
            end
            
            
            %查询510050持仓
            [errorCode,errorMsg,packet] = QueryCombiStock(connection,token,accountCode,combiNo,marketNo,stockCode);
            if errorCode < 0
                disp(['查持仓失败。错误信息为:',errorMsg]);
%                 Logout(connection,token);
%                 delete(heartbeatTimer);
                return;
            else
%                 disp('-------------持仓信息--------------');
%                 PrintPacket2(packet); %打印持仓信息
                self.current_holding_q = packet.getDoubleByIndex(10);
            end
        end
        
    end
    
    
    

    
    
    
end