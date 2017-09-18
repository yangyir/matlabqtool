classdef OptPricer < OptInfo
%OPTPRICER 运用理论计算期权价格，目前只使用BS理论
%calcIntrinsicValue需要变量K和S计算
%calcMoneyness需要变量S和K计算
%calcPx需要变量S|K|r|tau|sigma( tau需要T和currentDate计算 )计算
%calcTimeValue需要变量S|K|r|tau|sigma( tau需要T和currentDate计算 )计算
%calcDelta需要变量S|K|r|tau|sigma( tau需要T和currentDate计算 )计算
%calcGamma需要变量S|K|r|tau|sigma( tau需要T和currentDate计算 )计算
%calcTheta需要变量S|K|r|tau|sigma( tau需要T和currentDate计算 )计算
%calcRho需要变量S|K|r|tau|sigma( tau需要T和currentDate计算 )计算
% -------------------------------------------------------------
% 程刚，2060124, 写了demo
% [hfig] = plot_optprice_S(obj); % 画期权价格对S的图
% [hfig] = plot_delta_S(obj); % 画期权delta对S的图
% TODO：[何康，沈杰] 完成calcGamma， calcVega， calcTheta，calcRho
% TODO：[何康，沈杰] 学习demo，完成各种画图函数
% 程刚，20160124，增加了复制构造函数
% 吴云峰，20160129，修改了所有作图函数，增加了注释
% 程刚，20160202，改写M属性，Dependent=true， 用get.M方法，没有set.M(不能set， 不能赋值）
% 吴云峰，20160217，新加计算保证金的公式
% 吴云峰，20160229，增加一个init_from_sse_excel的方法
% 吴云峰 20170524 为了能够读取商品期权合约OptCommodityInfo，修改了init_from_sse_excel的BUG
 
    properties
 
        % 这些是从OptInfo继承的变量        
        % code = 10000000;        % 期权代码,形同 10000283,数值型
        % optName = '无名期权';    % 形同 '50ETF3月购2200',字符串
        % underCode = 510050;     % 标的代码,形同 510050,数值型
        % CP = 'call';            % 'C', 'c', 'Call', 'call', 'CALL' OR 'P', 'p', 'put', 'Put', 'PUT'
        % K = 0;                  % 期权执行价格
        % T;                      % 期权到期时间,数值型日期，如datenum('2016-1-27')
        % multiplier = 10000;     % 合约乘数
        % currentDate;            % 今天日期,数值型日期，即 today
        % tau = 0;                % 年化剩余时间, (T - currentDate)/365
        % ST;                     % 到期价格
        % payoff;                 % 期权的到期回报
        
        % 输入变量
        sigma = 0.3;              % 波动率(这里的波动率要基于VolSurface去获取)
        S = 2;                    % underlier的当前价格
        r = 0.05;                 % 无风险利率               
        model = 'BS';             % 使用的模型，暂时没有意义
        
        % 计算量
        intrinsicValue;           % 内在价值， （S-K)+ 或 （K-S)+
        timeValue;                % 时间价值
        px;                       % 期权价格
        
        % greeks
        delta;
        gamma;
        vega;
        theta;
        rho;     
        
    end
    
    properties(Dependent = true, Hidden = true)
        % moneyness， S/K 或 ln(S/K)
        M;                        
    end
    
    %% 计算的方法
    methods
        
        function mg = margin( self )
            % 开仓保证金
            % 最低标准
            % 认购期权义务仓开仓保证金＝[合约前结算价+Max（12%×合约标的前收盘价-认购期权虚值，7%×合约标的前收盘价）] ×合约单位
            % 认沽期权义务仓开仓保证金＝Min[合约前结算价+Max（12%×合约标的前收盘价-认沽期权虚值，7%×行权价格），行权价格] ×合约单位
            % 维持保证金
            % 最低标准
            % 认购期权义务仓维持保证金＝[合约结算价+Max（12%×合约标的收盘价-认购期权虚值，7%×合约标的收盘价）]×合约单位
            % 认沽期权义务仓维持保证金＝Min[合约结算价 +Max（12%×合标的收盘价-认沽期权虚值，7%×行权价格），行权价格]×合约单位
            % 其中，认购期权虚值=Max（行权价-合约标的收盘价，0）
            % 认沽期权虚值=max（合约标的收盘价-行权价，0）
            self.calcIntrinsicValue;
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL', '认购', '购',1 }
                    mg = self.px + max( self.S*0.12 - self.intrinsicValue, self.S *0.07 );
                case {'P', 'p', 'put', 'Put', 'PUT', '认沽',  '沽', 2}
                    mg = min( self.px + max( self.S*0.12 - self.intrinsicValue,  self.K*0.07 ), self.K );                    
            end
            
        end
        
        % 计算intrinsic value
        function [inValue] = calcIntrinsicValue( self )
            % 首先要有数据K和S
            tmp = self.S - self.K;
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    inValue = max(  tmp , zeros( size(tmp) )  );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    inValue = max( -tmp , zeros( size(tmp) )  );
            end  
            self.intrinsicValue = inValue;
        end
        
        function m = get.M(self)
            m = self.S/self.K;
        end
        
        
        function [px] = calcPx(self)
            % 算期权定价
%             self.calcTau; 
            if(isnan(self.sigma))
                self.px = 0.001;
                return;
            end
            switch self.model
                case {'BS'}
                    [call, put] = blsprice(self.S, self.K, self.r, self.tau, self.sigma, 0);
                otherwise
                    error('未知模型');
            end
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    px = call;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    px = put;
            end            
            self.px = px;
        end
        
        function [timeValue] = calcTimeValue(self)
            % 算期权的时间价值
            self.calcPx;
            self.calcIntrinsicValue;
            timeValue = self.px - self.intrinsicValue;
            self.timeValue = timeValue;            
        end
       
%% ------------------Greeks--------------------------    
      
        function [delta] = calcDelta(self)
            % 算期权的delta
            [cDelta, pDelta] = blsdelta(self.S, self.K, self.r, self.tau, self.sigma, 0);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    delta = cDelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    delta = pDelta;
            end
            self.delta = delta;
        end
        
 %%%%%%%%%%%%%%%%%%%%%%%%新增的希腊字母%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
 
       % 计算期权的Gamma，沈杰
       function [gamma] = calcGamma(self)
           % 算期权的Gamma,Call和Put的Gamma是一样的
            gamma = blsgamma(self.S, self.K, self.r, self.tau, self.sigma, 0);          
            self.gamma = gamma;
       end
       
       % 算期权的Vega,Call和Put的Vega是一样的
       function [vega] = calcVega(self)  
           vega = blsvega(self.S, self.K, self.r, self.tau, self.sigma, 0);          
           self.vega = vega;
       end
       
        % 算期权的theta
        function [theta] = calcTheta(self)          
            [cTheta, pTheta] = blstheta(self.S, self.K, self.r, self.tau, self.sigma, 0);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    theta = cTheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    theta = pTheta;
            end
            self.theta = theta;
        end
       
        function [rho] = calcRho(self)
            % 算期权的rho
            [cRho, pRho] = blsrho(self.S, self.K, self.r, self.tau, self.sigma, 0);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    rho = cRho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    rho = pRho;
            end
            self.rho = rho;
        end
        
    end
     
    %% 输出型的方法
    
    % 这里的方法是输出图、文、word文档等

    methods(Access = 'public', Static = false, Hidden = false)
        
        [hfig] = plot_optprice_S(obj); % 画期权价格对S的图
        [hfig] = plot_optprice_tau(obj); % 画期权价格对tau的图
        [hfig] = plot_optprice_r(obj); % 画期权价格对r的图
        [hfig] = plot_optprice_sigma(obj); % 画期权价格对sigma的图
        [hfig] = plot_delta_S(obj); % 画期权delta对S的图   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%新增
        
        %%%%%%%%%%增加的希腊字母
        [hfig] = plot_gamma_S(obj); % 画期权gamma对S的图
        [hfig] = plot_vega_S(obj); % 画期权vega对S的图
        [hfig] = plot_theta_S(obj); % 画期权theta对S的图
        [hfig] = plot_rho_S(obj); % 画期权rho对S的图
        
        %%%%%%%%%%greeks~tau
        [hfig] = plot_gamma_tau(obj); % 画期权gamma对tau的图
        [hfig] = plot_vega_tau(obj); % 画期权vega对tau的图
        [hfig] = plot_theta_tau(obj); % 画期权theta对tau的图
        [hfig] = plot_rho_tau(obj); % 画期权rho对tau的图

        %%%%%%%%%%greeks~K
        [hfig] = plot_gamma_K(obj); % 画期权gamma对K的图
        [hfig] = plot_vega_K(obj); % 画期权vega对K的图
        [hfig] = plot_theta_K(obj); % 画期权theta对K的图
        [hfig] = plot_rho_K(obj); % 画期权rho对K的图
        
        %%%%%%%%%%greeks~sigma
        [hfig] = plot_gamma_sigma(obj); % 画期权gamma对K的图
        [hfig] = plot_vega_sigma(obj); % 画期权vega对K的图
        [hfig] = plot_theta_sigma(obj); % 画期权theta对K的图
        [hfig] = plot_rho_sigma(obj); % 画期权rho对K的图
        
        %%%%%%%%%% 新增的4张图
        [ hfig ] = plot_px_delta_gamma_S(obj); % 将px~S,delta~S,gamma~S画一起
        [ hfig ] = plot_px_rho_R( obj ); % 将px~R，rho~S画一起
        [ hfig ] = plot_px_vega_sigma( obj);%将px~sigma,vega~sigma画一起
        [ hfig ] = plot_px_theta_tau( obj );%将px~tau,theta~S画一起
        
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         [ hfig ] = plot_delta_tau_mix( obj );
         [ hfig ] = plot_rho_tau_mix( obj );
         [ hfig ] = plot_theta_tau_mix( obj );
    end
    
    %% static的方法
    methods( Static = true )
        
        % 在这里面做研究
        demo_plot;
        demo2; 
        demo3;
        % 增加了一个Pricer从Excel里面获取的方法
        [ pricer , m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( optInfoxlsx );
        
    end
    
    %% 复制构造函数
    methods(Hidden = false)
        
        % 复制构造函数
        [ newobj ] = getCopy( obj );
        
    end
    
end

