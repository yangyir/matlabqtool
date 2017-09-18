classdef Deltahedging2 <handle
    
    properties(Hidden = false)       
        book@Book = Book;  % 投资组合信息，只负责记录清楚就行了，原则上不参与策略逻辑
        
        
        freq = [];
        total_val = [];
        invest_frac = 10000;
        num_option_lot = 1;  % 持有期权的手数（始终持有这么多）
        cash = 0;
        
        
        % 环境信息
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
        option_multiplier = 10000;
        optPricer = OptPricer;
    end
         
    % 账户信息, 初始化后不再改动
    properties(SetAccess = 'private', Hidden = true )
        counter     = CounterHSO32;  % O32柜台
        marketNo    = '1';         %交易市场
        stockCode   = '510050';   %证券代码        
    end
        
        
        
        
    %% 下单相关函数，  OMS， EMS    
    methods
        [self] = openfire(self)
        
        % delta的计算
        function self = cal_delta(self)
            op = self.optPricer;
            op.S = self.current_underling_price;
            self.current_delta = op.calcDelta;
        end
        
        function self = BS_option_price(self)            
            self.theoretical_price = self.optPricer.calcPx();
         end        
    end
      
    
    %% 初始化和logout的函数
    methods
        
        % option默认值
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
                        
            self.past_delta = self.current_delta; % 加上去的
        end
            
        
        
        
         %%  连接实盘.  默认登陆设置，并连接、登陆、心跳
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
            self.stockCode  = '510050';   %证券代码    
            
        end
        
        
        function self = logout(self)
                %退出登录
            self.counter.logout;
        end
        
        
        
        
    end
    
    
    
    %% 取行情和组合状态的函数， QMS，PMS
    methods
        %% 取S的当前价格
        function [px] = get_current_price(self)
            marketNo = self.marketNo;
            stockCode = self.stockCode;
            
            [errorCode,errorMsg,packet] = self.counter.queryCombiStock(marketNo,stockCode);
%             -------------获得持仓信息--------------
%             [0]ErrorCode	[1]ErrorMsg	[2]MsgDetail	[3]DataCount
%             [0]0	[1]	[2]	[3]0
            
            if errorCode < 0
                disp(['查持仓失败。错误信息为:',errorMsg]);
                return;
            else
%                 disp('-------------获得持仓信息--------------');
%                 PrintPacket2(packet); %打印持仓信息
            end
            px = packet.getDoubleByIndex(16);
            self.current_underling_price = px;
            self.optPricer.S = px;
        end
        
         % 更新组合的状态： 50etf持仓和现金
        function [] = update_portfolio(self)
            marketNo    = self.marketNo;
            stockCode   = '510050';
            
            %查询资金
            [errorCode,errorMsg,packet] = self.counter.queryAccount();
            if errorCode < 0
                disp(['查资金失败。错误信息为:',errorMsg]);
                return;
            else
%                 disp('-------------资金信息--------------');
%                 PrintPacket2(packet); %打印资金信息
                self.cash =  packet.getDoubleByIndex(3);
            end
            
            
            %查询510050持仓
            [errorCode,errorMsg,packet] = self.counter.queryCombiStock(marketNo,stockCode);
            if errorCode < 0
                disp(['查持仓失败。错误信息为:',errorMsg]);
                return;
            else
%                 disp('-------------持仓信息--------------');
%                 PrintPacket2(packet); %打印持仓信息
                self.current_holding_q = packet.getDoubleByIndex(10);
            end
        end
        
    end
    
    
    

    
    
    
end