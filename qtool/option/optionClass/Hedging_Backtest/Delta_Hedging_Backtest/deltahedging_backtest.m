classdef deltahedging_backtest < handle 
    % Delta�Գ巽���Ļز��ຯ��
    % -----------------------------------------------
    % ���㣬20160125 ������ܼ�飩
    % 
    
    
    properties
    % ���ݴ��
    underling_data = [];   
    data_len = [];
    data_time = [];
    data_call = [];
    data_put = [];
    
    
    % �ʽ�����    
    total_val = [];
    invest_frac = [];%Ͷ�ʱ���
    cash = [];
    
    % parameters for trading
    trading_cost = 0.0003;
    slippage = 0.001;
    
    % �Գ�ʱ������
    base_time_interval = 5; % minutes
    hedge_time_interval = 10; %minutes
    
    
    % imput parameters for option
    r = 0.05;
    K = 2.2;
    vol = 0.30;
    mature_time = '2016-03-25';
    option_type = 'call';
    
    
    % outputs
    theo_price = [];       % ������Ȩ�۸�����
    delta_seq = [];
    holding_seq = [];
    
    hedging_pnl = [];
    theo_option_pnl = []; 
    hedging_cpnl = [];     
    theo_option_cpnl = [];    
    real_option_pnl = [];  % ��ʵ��ȨPNL���� 
    real_option_cpnl = [];  % �ۼ�PNL����
    end
    
    %% Supporting Methods 
     % �������������ⲿ��
    methods
        
        % ��ʼ���������貹�� 
        function self = init_etf50settings(self)
        % ������Ҫ��ǰ׼��
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
        
         % ����������Ȩ�ļ۸�       
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
        
        % ����������Ȩ������
        function cal_theo_option_pnl(self)
            
            y = self.theo_price; % ��Ȩ���ۼ۸�����
            % 
            holding = round(self.total_val*self.invest_frac/10000)*10000;
            self.theo_option_pnl = [0;holding*(y(2:end)-y(1:end-1))];
            %self.theo_option_cpnl = cumsum(self.theo_option_pnl);
            self.theo_option_cpnl = y*holding - y(1)*holding;
        end        
        
        % ����delta����
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
        
        % ����delta�Գ����� 
        function cal_hedging_pnl(self)
            y = self.underling_data;
            pnl = [0;self.holding_seq(1:end-1).*(y(2:end)-y(1:end-1))];
            
            cost_seq = self.trading_cost*[self.holding_seq(1);abs(diff(self.holding_seq))];
            
            self.hedging_pnl =  pnl - cost_seq;
            self.hedging_cpnl =  cumsum(self.hedging_pnl);

        end

        % ��ͼ
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
    
    %% Delta Hedging Methods ���ֶԳ巽��������
    methods
        function deltahedging_holdingseq_et(self)
           % ��ʱ�������� 
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