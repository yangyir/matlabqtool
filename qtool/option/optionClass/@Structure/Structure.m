classdef Structure < handle 
    %STRUCTURE 是多个期权组合出来的东西
    %inject_environment_params将当前的S|r|volsurf赋予给了所有的optPricers变量
    %注意！calcPayoff是针对的optInfos变量，其他所有的计算函数均是针对optPricers函数
    %calcPayoff不存在初始化环境变量的方法inject_environment_params
    % ---------------------------------------------------------------
    % 吴云峰，20160120
    % 程刚，20160120，改了calcTotalPayoff, 兼容2维的optInfo和num
    % 吴云峰，20160120，增加了calcTotalReturn， 同样也需要兼容2维的optInfo和num
    % 程刚，20160124，增加了复制构造函数
    % 程刚，20160124，加入Pricer相关的一切，通过optPricer算，再加总，不是最好的思路
    % 吴云峰，20160129，增加了Pricer的画图
    % 吴云峰，20100229，将volsurf修改为了波动率曲面的类( 一些作图函数和一些Demo可能就需要修改 )
    % 朱江，20160329， 增加calc_delta0_S0方法, 用于计算使得delta=0的点S0
    % 朱江，20161215, 增加设置环境vol,tau,S方法，其中tau是变化量。
    %% 变量
    properties
        
        optInfos@OptInfo     = OptInfo;    % 期权合约的数组
        optPricers@OptPricer = OptPricer;  % 算组合定价用
        num = 1;                           % 数目
        
        % 输入变量
        % 假定VolSurface是已知给定的
        volsurf@VolSurface;      % 波动率曲面
        S;                       % underlier的当前价格
        r = 0.05;                % 无风险利率               
        model = 'BS';            % 使用的模型，暂时没有意义
        % 计算量
        M;                       % moneyness， S/K 或 ln(S/K)       
        intrinsicValue;          % 内在价值， （S-K)+ 或 （K-S)+
        timeValue;               % 时间价值
        px;                      % 期权价格
                
        % 计算量
        payoff;                  % 总体payoff
        retrn;                   % 总体return
        
        % greeks
        delta;
        gamma;
        vega;
        theta;
        rho;     
        
    end
    
    
    %% 构造函数、复制构造函数
    methods(Hidden = true)
        
        % 构造函数
        function obj = Structure()            
        end
        
        % 复制构造函数
        [ newobj ] = getCopy( obj );        
    end
    
    %% 计算用的方法
    
    methods
        
        % 这个方法一定需要在最开始进行数值的赋予
        function inject_environment_params(obj)
            % 把structure的环境变量赋给每一个optPricer
            % 要从surf上取值, 必须得采用插值的方法
            vs = obj.volsurf;
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.S     = obj.S;
                    op.r     = obj.r;
                    % 注意这个OptPricer的T必须是服从最近的4天来获取
                    sigma = vs.calc_Sigma( op.T , op.S , op.K , op.CP );
                    if isnan(sigma)
                        sigma = 0.0001;
                    end
                    op.sigma = sigma;
                end
            end
        end
        
        % 手动设置波动水平
        function set_environment_vol(obj, vol)
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.sigma = vol;
                end
            end
        end
        
        % 手动设置tau变化量
        function set_environment_tau(obj, tau)
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.tau   = op.tau + tau;
                end
            end
        end
        
        % 手动设置S
        function set_environment_S(obj, S)
            obj.S = S;
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.S   = S;
                end
            end
        end
        
        %% 各种calc函数
        function [] = calcAll(obj)
            obj.calcPx;
            obj.calcIntrinsicValue;
            obj.calcTimeValue;
            obj.calcDelta;
            obj.calcGamma;
            obj.calcVega;
            obj.calcTheta;
        end
        
        function [inValue] = calcIntrinsicValue( obj )
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            inValue = 0;
            [ L1, L2 ] = size(obj.optPricers);
            for j = 1:L1
                for i = 1:L2                    
                    op      = obj.optPricers(j,i);
                    nums    = obj.num(j,i);
                    % 可以不用乘数
                    inValue = inValue + nums * op.calcIntrinsicValue();
                end
            end 
            obj.intrinsicValue = inValue;
        end 
        
        % 算给定ST的payoff值
        function [ payoff ] = calcPayoff( obj, ST )
            % 注意calcPayoff是基于optInfos的计算而实现的
            % 而其他的计算的函数大多数是optPricers的
            payoff = 0 ;
            % 可以接纳二维的optInfos
            [ L1, L2 ] = size(obj.optInfos);
            for j = 1:L1
                for i = 1:L2
                    oi      = obj.optInfos(j,i);
                    nums    = obj.num(j,i);
                    % 可以不用乘数
                    payoff  = payoff + nums * oi.calcPayoff( ST );
                end
            end 
            obj.payoff = payoff;
        end
        

        % 计算期权组合的定价
        function [px] = calcPx(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            px = 0.0;
            % 可以接纳二维的optPricers
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    nums    = self.num(j,i);
                    try
                    op.calcPx();
                    catch e
                        disp(e);
                        disp(['pricer ( ', num2str(j), ',', num2str(i), ')']);
                    end
                    px = px + nums * op.px;
                end
            end
            self.px = px;
        end
        
        % 计算期权的时间价值
        function [timeValue] = calcTimeValue(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            timeValue = 0.0;
            % 可以接纳二维的optPricers
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    nums    = self.num(j,i);
                    op.calcTimeValue();
                    timeValue = timeValue + nums * op.timeValue;
                end
            end
            self.timeValue = timeValue;         
        end
         
        % 计算期权组合的Delta
        function [delta] = calcDelta(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            delta = 0.0;
            % 可以接纳二维的optPricers
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    nums    = self.num(j,i);
                    op.calcDelta();
                    delta = delta + nums * op.delta;
                end
            end
            self.delta = delta;
        end
        
        %  计算使得delta=0的点S0
        [S0, delta0] = calc_delta0_S0(obj, S_min, S_max, step, flagVolsurfAccuracy);
        
        
        function [cpGamma] = calcGamma(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            cpGamma = 0;
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    nums    = self.num(j,i);
                    op.calcGamma();
                    cpGamma = cpGamma + nums * op.gamma;
                end
            end
            self.gamma = cpGamma;
        end
        
        function [cpVega] = calcVega(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            cpVega = 0;
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    nums    = self.num(j,i);
                    op.calcVega();
                    cpVega = cpVega + nums * op.vega;
                end
            end
            self.vega = cpVega;
        end
        
        function [theta] = calcTheta(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            theta = 0;
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    n       = self.num(j,i);
                    op.calcTheta();
                    theta = theta + n * op.theta;
                end
            end
            self.theta = theta;
        end
        
        function [rho] = calcRho(self)
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            rho = 0;
            [ L1, L2 ] = size(self.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = self.optPricers( j , i );
                    nums    = self.num(j,i);
                    op.calcRho();
                    rho = rho + nums * op.rho;
                end
            end
            self.rho = rho;
        end

        % Structure组合的总体回报
        function [ ret ] = calcReturn( obj , ST )
            % 应该最开始将环境变量进行赋予，赋予一次后面的就可以不用加
            % self.inject_environment_params();
            ret = 0.0;
            % 可以接纳二维的optPricers
            [ L1, L2 ] = size(obj.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = obj.optPricers( j , i );
                    nums    = obj.num(j,i);
                    % 需要减去期权价格
                    ret     = ret + nums*( op.calcPayoff( ST ) - op.px );
                end
            end
            % 注意,这个价格可以是期权的实时价格还是期权的定价
            obj.retrn = ret;
            
        end           
        
        function [delta1] = calcDelta1(obj)
            delta1 = obj.delta * 10000 * obj.S * 0.01;
        end
        
        function [gamma1] = calcGamma1(obj)
            gamma1 = obj.gamma * 10000 * obj.S * 0.01 * obj.S * 0.01 * 0.5;
        end
        
        function [vega1] = calcVega1(obj)
            vega1 = obj.vega * 10000 * 0.01;
        end
        
        function [theta1] = calcTheta1(obj)
            theta1 = obj.theta * (1 / 252);
        end
    end
    
    %% 画图的方法
    methods
         [ hfig ] = drawPayoff( obj , ST, cost )
         
         % TODO: OptPricer中的几十个画图方法，应该在这里实现
         
        [hfig] = plot_optprice_S( self, S_values);     % 画期权价格对S的图
        [hfig] = plot_optprice_tau( self, tau );   % 画期权价格对tau的图
        [hfig] = plot_optprice_r( self );     % 画期权价格对r的图
        [hfig] = plot_optprice_sigma( self ); % 画期权价格对sigma的图
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%新增
        
        %%%%%%%%%%增加的希腊字母
        [hfig] = plot_delta_S( self ); % 画期权delta对S的图   
        [hfig] = plot_gamma_S( self ); % 画期权gamma对S的图
        [hfig] = plot_vega_S( self );  % 画期权vega对S的图
        [hfig] = plot_theta_S( self ); % 画期权theta对S的图
        [hfig] = plot_rho_S( self );   % 画期权rho对S的图
        
        %%%%%%%%%%greeks~tau
        [hfig] = plot_gamma_tau( self );    % 画期权gamma对tau的图
        [hfig] = plot_vega_tau( self );     % 画期权vega对tau的图
        [hfig] = plot_theta_tau( self );    % 画期权theta对tau的图
        [hfig] = plot_rho_tau( self );      % 画期权rho对tau的图
        
        [ hfig ] = plot_gamma_tau_mix( obj );
        [ hfig ] = plot_delta_tau_mix( obj );
        [ hfig ] = plot_rho_tau_mix( obj );
        [ hfig ] = plot_theta_tau_mix( obj );

        %%%%%%%%%%greeks~K
        [hfig] = plot_gamma_K( self ); % 画期权gamma对K的图
        [hfig] = plot_vega_K( self );  % 画期权vega对J的图
        [hfig] = plot_theta_K( self ); % 画期权theta对J的图
        [hfig] = plot_rho_K( self );   % 画期权rho对J的图
        
        %%%%%%%%%% 新增的4张图
        [ hfig ] = plot_px_delta_gamma_S( self ); % 将px~S,delta~S,gamma~S画一起
        [ hfig ] = plot_px_rho_R( self );         % 将px~R，rho~S画一起
        [ hfig ] = plot_px_vega_sigma( self );    % 将px~sigma,vega~sigma画一起
        [ hfig ] = plot_px_theta_tau( self );     % 将px~tau,theta~S画一起
        
    end
    
    %% static方法
    methods(Access = 'public', Static = true, Hidden = false)
        % 一个基于OptInfo为基础的Demo
        demo;
        % 一个基于OptPricer来验证作图和volsurface的Demo
        demo2;
        % 把positionArray转换成structure，看风险
        demo3;
    end
    
end

