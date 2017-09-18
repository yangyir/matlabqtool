classdef hedging_error < handle
    % this class is for hedging error study
    
    properties 
        
        % for simulated data
        S0 = 2;
        mu = 0.05;
        vol = 0.3;
        len = 100;
        S_path = [];
        data_type = 'BM';
        
        
        
        % for options
        vol_high = 0.45;
        vol_low = 0.2;
        K = 2.0;
        r = 0.05;
        option_type = 'call'
        c0_path = [];
        c_low_path = [];
        c_high_path = [];
        
        % for hedging
        delta0 = [];
        delta_low = [];
        delta_high = [];
        
        delta0_cpnl = [];
        deltalow_cpnl = [];
        deltahigh_cpnl = [];
        
    end
    

    methods
        % 产生数据
        function self = gen_data(self)
            % generate data
            % BM = Brownian Motion; WN = White Noise; Up_Trend; Down_Trend
            % vol of the simulated data must be exactly equal self.vol
            self.S_path = zeros(self.len,1);
            self.S_path(1) = self.S0;
            
            switch self.data_type
                case 'BM'

                    for i = 2:self.len
                        self.S_path(i) = self.S_path(i-1)*(1 + randn*self.vol*sqrt(1/250));
                    end
            
                case  'WN'
                    for i = 2:self.len
                        self.S_path(i) = self.S0*(1 + randn*self.vol/sqrt(2)*sqrt(1/250));
                    end                    
            
                case  'Up_Trend'
                    
                    for i = 2:self.len
                        self.S_path(i) = self.S0*(1 + self.mu*i/10 + randn*self.vol*sqrt(1/250));
                    end
                case  'Down_Trend'
                    
                    for i = 2:self.len
                        self.S_path(i) = self.S0*(1 -self.mu*i/10 + randn*self.vol*sqrt(1/250));
                    end                    
                    
            end
            
            real_vol = std(diff(self.S_path)./self.S_path(1:end-1))*sqrt(250);
            S_ret = [0;diff(self.S_path)./self.S_path(1:end-1)*self.vol/real_vol];
            self.S_path = self.S0*cumprod(1+S_ret);
            
        end
        
        
   
        
        
        
        
        %计算理论期权价格
        function self = cal_theo_price(self)
            
            self.c0_path = zeros(self.len,1);
            self.c_low_path = zeros(self.len,1);
            self.c_high_path = zeros(self.len,1);
            
            for i = 1:self.len
                s = self.S_path(i);
                tau = (self.len - i +1)/250;
                [c_price,p_price] = blsprice(s,self.K,self.r,tau,self.vol,0);
                if strcmp(self.option_type,'call')==1
                    self.c0_path(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    self.c0_path(i) = p_price;
                end
                
                [c_price,p_price] = blsprice(s,self.K,self.r,tau,self.vol_high,0);
                if strcmp(self.option_type,'call')==1
                    self.c_high_path(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    self.c_high_path(i) = p_price;
                end                
                
                 [c_price,p_price] = blsprice(s,self.K,self.r,tau,self.vol_low,0);
                if strcmp(self.option_type,'call')==1
                    self.c_low_path(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    self.c_low_path(i) = p_price;
                end               
                
                
            end
            
        end
        
        
        
        function self = cal_delta(self)
            
            self.delta0 = zeros(self.len,1);
            self.delta_low = zeros(self.len,1);
            self.delta_high = zeros(self.len,1);
            for i = 1:self.len
                s = self.S_path(i);
                tau = (self.len - i +1)/250;
                [c_price,p_price] = blsdelta(s,self.K,self.r,tau,self.vol,0);
                if strcmp(self.option_type,'call')==1
                    self.delta0(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    self.delta0(i) = p_price;
                end
                
                [c_price,p_price] = blsdelta(s,self.K,self.r,tau,self.vol_high,0);
                if strcmp(self.option_type,'call')==1
                    self.delta_high(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    self.delta_high(i) = p_price;
                end                
                
                 [c_price,p_price] = blsdelta(s,self.K,self.r,tau,self.vol_low,0);
                if strcmp(self.option_type,'call')==1
                    self.delta_low(i) = c_price;
                elseif strcmp(self.option_type,'put')==1
                    self.delta_low(i) = p_price;
                end               
                
                
            end
            
        end            
        
        
        function self = cal_cpnl(self)
            
            delta0_pnl = [0;self.delta0(1:end-1).*(self.S_path(2:end)-self.S_path(1:end-1))];
            self.delta0_cpnl = cumsum(delta0_pnl);
            deltalow_pnl = [0;self.delta_low(1:end-1).*(self.S_path(2:end)-self.S_path(1:end-1))];
            self.deltalow_cpnl = cumsum(deltalow_pnl);
            deltahigh_pnl = [0;self.delta_high(1:end-1).*(self.S_path(2:end)-self.S_path(1:end-1))];
            self.deltahigh_cpnl = cumsum(deltahigh_pnl);
            
            
        end
        
        
    end
    
    
    
    
    
    
end