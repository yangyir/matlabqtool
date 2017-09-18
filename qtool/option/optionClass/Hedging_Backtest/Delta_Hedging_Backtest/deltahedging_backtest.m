classdef deltahedging_backtest < handle 
    % Delta对冲方法的回测类函数
    % -----------------------------------------------
    % 黄勉，20160125 （请沈杰检查）
    % 
    
    
    properties
    % 数据存放
    underling_data = [];   
    data_len = [];
    data_time = [];
    data_call = [];
    data_put = [];
    
    
    % 资金设置    
    total_val = [];
    invest_frac = [];%投资比例
    cash = [];
    
    % parameters for trading
    trading_cost = 0.0003;
    slippage = 0.001;
    
    % 对冲时间设置
    base_time_interval = 5; % minutes
    hedge_time_interval = 10; %minutes
    
    
    % imput parameters for option
    r = 0.05;
    K = 2.2;
    vol = 0.30;
    mature_time = '2016-03-25';
    option_type = 'call';
    
    
    % outputs
    theo_price = [];       % 理论期权价格序列
    delta_seq = [];
    holding_seq = [];
    
    hedging_pnl = [];
    theo_option_pnl = []; 
    hedging_cpnl = [];     
    theo_option_cpnl = [];    
    real_option_pnl = [];  % 真实期权PNL序列 
    real_option_cpnl = [];  % 累计PNL序列
    end
    
    %% Supporting Methods 
     % 基础函数放在这部分
    methods
        
        % 初始化函数，需补充 
        function self = init_etf50settings(self)
        % 数据需要提前准备
            load data_etf
            load data_call
            load data_put
            load data_time
            self.underling_data = data_etf;
            self.data_time = data_time;
            self.data_call = data_call;
            self.data_put = data_put;
            self.data_len = length(data_etf);
            
        end
        
         % 计算理论期权的价格       
        function self = cal_theo_price(self)       
            len = self.data_len;
            y = self.underling_data;            
            r = self.r;
            K = self.K;
            vol = self.vol;
            c0 = zeros(len,1);
            
            for i = 1:len
                s = y(i);
                tau = (datenum(self.mature_time)-self.data_time(i))/365;
                [c_price,p_price] = blsprice(s,K,r,tau,vol,0);
                if strcmp(self.option_type,'call')==1
                    c0(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    c0(i) = p_price;
                elseif strcmp(self.option_type,'strip')==1
                    c0(i) = c_price + p_price;
                end
                
            end
            self.theo_price = c0;
            
        end
        
        % 计算理论期权的损益
        function cal_theo_option_pnl(self)
            
            y = self.theo_price; % 期权理论价格序列
            % 
            holding = round(self.total_val*self.invest_frac/10000)*10000;
            self.theo_option_pnl = [0;holding*(y(2:end)-y(1:end-1))];
            %self.theo_option_cpnl = cumsum(self.theo_option_pnl);
            self.theo_option_cpnl = y*holding - y(1)*holding;
        end        
        
        % 计算delta序列
        function update_deltaseq(self)
            
            len = self.data_len;
            y = self.underling_data;
            r = self.r;
            K = self.K;
            vol = self.vol;            
            delta = zeros(len,1);
            
            for i = 1:len
                s = y(i);
                tau = (datenum(self.mature_time)-self.data_time(i))/365;
                [c_delta,p_delta] = blsdelta(s,K,r,tau,vol,0);
                if strcmp(self.option_type,'call')==1
                    delta(i) = c_delta;
                elseif strcmp(self.option_type,'put')==1
                    delta(i) = p_delta;
                elseif strcmp(self.option_type,'strip')==1
                    delta(i) = c_delta + p_delta;
                end
                
            end

            self.delta_seq = delta;
            
            
        end
        
        % 计算delta对冲损益 
        function cal_hedging_pnl(self)
            y = self.underling_data;
            pnl = [0;self.holding_seq(1:end-1).*(y(2:end)-y(1:end-1))];
            
            cost_seq = self.trading_cost*[self.holding_seq(1);abs(diff(self.holding_seq))];
            
            self.hedging_pnl =  pnl - cost_seq;
            self.hedging_cpnl =  cumsum(self.hedging_pnl);

        end

        % 画图
        function comparison_plot(self)
            
            figure();
            hold on;
            plot(self.hedging_cpnl,'r');
            plot(self.theo_option_cpnl,'b');
            legend('hedging pnl','theoretical option pnl')
%             grid on 
%             txt = sprintf('%s(K=%0.2f,T=%s), sigma=%0.0f%%,r=%0.2f',...
%             self.option_type,self.K,self.mature_time,self.vol*100,self.r);
%             title(txt)
%                
            hold off;
            
            
        end

    end
    
    %% Delta Hedging Methods 各种对冲方法的设置
    methods
        function deltahedging_holdingseq_et(self)
           % 等时间间隔调整 
           % obtain holding using delta hedging
           % equal time adjustment for delta
           len = self.data_len;
           y = self.underling_data;
           holding = zeros(len,1);
           %holding_multiplier = 100;
           
           deno = self.hedge_time_interval/self.base_time_interval;
           
           for i = 1:len
               k = mod(i-1,deno);
               current_delta = self.delta_seq(i-k);
               
               holding(i) = round(self.total_val*self.invest_frac*current_delta/100)*100;
               
           end
           
            self.holding_seq = holding;
            
        end     
        


        
        
        
        
        
        
    end
    
    
    
end