classdef Structure < handle 
    %STRUCTURE �Ƕ����Ȩ��ϳ����Ķ���
    %inject_environment_params����ǰ��S|r|volsurf����������е�optPricers����
    %ע�⣡calcPayoff����Ե�optInfos�������������еļ��㺯���������optPricers����
    %calcPayoff�����ڳ�ʼ�����������ķ���inject_environment_params
    % ---------------------------------------------------------------
    % ���Ʒ壬20160120
    % �̸գ�20160120������calcTotalPayoff, ����2ά��optInfo��num
    % ���Ʒ壬20160120��������calcTotalReturn�� ͬ��Ҳ��Ҫ����2ά��optInfo��num
    % �̸գ�20160124�������˸��ƹ��캯��
    % �̸գ�20160124������Pricer��ص�һ�У�ͨ��optPricer�㣬�ټ��ܣ�������õ�˼·
    % ���Ʒ壬20160129��������Pricer�Ļ�ͼ
    % ���Ʒ壬20100229����volsurf�޸�Ϊ�˲������������( һЩ��ͼ������һЩDemo���ܾ���Ҫ�޸� )
    % �콭��20160329�� ����calc_delta0_S0����, ���ڼ���ʹ��delta=0�ĵ�S0
    % �콭��20161215, �������û���vol,tau,S����������tau�Ǳ仯����
    %% ����
    properties
        
        optInfos@OptInfo     = OptInfo;    % ��Ȩ��Լ������
        optPricers@OptPricer = OptPricer;  % ����϶�����
        num = 1;                           % ��Ŀ
        
        % �������
        % �ٶ�VolSurface����֪������
        volsurf@VolSurface;      % ����������
        S;                       % underlier�ĵ�ǰ�۸�
        r = 0.05;                % �޷�������               
        model = 'BS';            % ʹ�õ�ģ�ͣ���ʱû������
        % ������
        M;                       % moneyness�� S/K �� ln(S/K)       
        intrinsicValue;          % ���ڼ�ֵ�� ��S-K)+ �� ��K-S)+
        timeValue;               % ʱ���ֵ
        px;                      % ��Ȩ�۸�
                
        % ������
        payoff;                  % ����payoff
        retrn;                   % ����return
        
        % greeks
        delta;
        gamma;
        vega;
        theta;
        rho;     
        
    end
    
    
    %% ���캯�������ƹ��캯��
    methods(Hidden = true)
        
        % ���캯��
        function obj = Structure()            
        end
        
        % ���ƹ��캯��
        [ newobj ] = getCopy( obj );        
    end
    
    %% �����õķ���
    
    methods
        
        % �������һ����Ҫ���ʼ������ֵ�ĸ���
        function inject_environment_params(obj)
            % ��structure�Ļ�����������ÿһ��optPricer
            % Ҫ��surf��ȡֵ, ����ò��ò�ֵ�ķ���
            vs = obj.volsurf;
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.S     = obj.S;
                    op.r     = obj.r;
                    % ע�����OptPricer��T�����Ƿ��������4������ȡ
                    sigma = vs.calc_Sigma( op.T , op.S , op.K , op.CP );
                    if isnan(sigma)
                        sigma = 0.0001;
                    end
                    op.sigma = sigma;
                end
            end
        end
        
        % �ֶ����ò���ˮƽ
        function set_environment_vol(obj, vol)
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.sigma = vol;
                end
            end
        end
        
        % �ֶ�����tau�仯��
        function set_environment_tau(obj, tau)
            [ L1, L2 ] = size( obj.optPricers );            
            for j = 1:L1
                for i = 1:L2                    
                    op       = obj.optPricers(j,i);
                    op.tau   = op.tau + tau;
                end
            end
        end
        
        % �ֶ�����S
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
        
        %% ����calc����
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
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
            % self.inject_environment_params();
            inValue = 0;
            [ L1, L2 ] = size(obj.optPricers);
            for j = 1:L1
                for i = 1:L2                    
                    op      = obj.optPricers(j,i);
                    nums    = obj.num(j,i);
                    % ���Բ��ó���
                    inValue = inValue + nums * op.calcIntrinsicValue();
                end
            end 
            obj.intrinsicValue = inValue;
        end 
        
        % �����ST��payoffֵ
        function [ payoff ] = calcPayoff( obj, ST )
            % ע��calcPayoff�ǻ���optInfos�ļ����ʵ�ֵ�
            % �������ļ���ĺ����������optPricers��
            payoff = 0 ;
            % ���Խ��ɶ�ά��optInfos
            [ L1, L2 ] = size(obj.optInfos);
            for j = 1:L1
                for i = 1:L2
                    oi      = obj.optInfos(j,i);
                    nums    = obj.num(j,i);
                    % ���Բ��ó���
                    payoff  = payoff + nums * oi.calcPayoff( ST );
                end
            end 
            obj.payoff = payoff;
        end
        

        % ������Ȩ��ϵĶ���
        function [px] = calcPx(self)
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
            % self.inject_environment_params();
            px = 0.0;
            % ���Խ��ɶ�ά��optPricers
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
        
        % ������Ȩ��ʱ���ֵ
        function [timeValue] = calcTimeValue(self)
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
            % self.inject_environment_params();
            timeValue = 0.0;
            % ���Խ��ɶ�ά��optPricers
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
         
        % ������Ȩ��ϵ�Delta
        function [delta] = calcDelta(self)
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
            % self.inject_environment_params();
            delta = 0.0;
            % ���Խ��ɶ�ά��optPricers
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
        
        %  ����ʹ��delta=0�ĵ�S0
        [S0, delta0] = calc_delta0_S0(obj, S_min, S_max, step, flagVolsurfAccuracy);
        
        
        function [cpGamma] = calcGamma(self)
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
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
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
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
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
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
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
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

        % Structure��ϵ�����ر�
        function [ ret ] = calcReturn( obj , ST )
            % Ӧ���ʼ�������������и��裬����һ�κ���ľͿ��Բ��ü�
            % self.inject_environment_params();
            ret = 0.0;
            % ���Խ��ɶ�ά��optPricers
            [ L1, L2 ] = size(obj.optPricers);
            for j = 1:L1
                for i = 1:L2
                    op      = obj.optPricers( j , i );
                    nums    = obj.num(j,i);
                    % ��Ҫ��ȥ��Ȩ�۸�
                    ret     = ret + nums*( op.calcPayoff( ST ) - op.px );
                end
            end
            % ע��,����۸��������Ȩ��ʵʱ�۸�����Ȩ�Ķ���
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
    
    %% ��ͼ�ķ���
    methods
         [ hfig ] = drawPayoff( obj , ST, cost )
         
         % TODO: OptPricer�еļ�ʮ����ͼ������Ӧ��������ʵ��
         
        [hfig] = plot_optprice_S( self, S_values);     % ����Ȩ�۸��S��ͼ
        [hfig] = plot_optprice_tau( self, tau );   % ����Ȩ�۸��tau��ͼ
        [hfig] = plot_optprice_r( self );     % ����Ȩ�۸��r��ͼ
        [hfig] = plot_optprice_sigma( self ); % ����Ȩ�۸��sigma��ͼ
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%����
        
        %%%%%%%%%%���ӵ�ϣ����ĸ
        [hfig] = plot_delta_S( self ); % ����Ȩdelta��S��ͼ   
        [hfig] = plot_gamma_S( self ); % ����Ȩgamma��S��ͼ
        [hfig] = plot_vega_S( self );  % ����Ȩvega��S��ͼ
        [hfig] = plot_theta_S( self ); % ����Ȩtheta��S��ͼ
        [hfig] = plot_rho_S( self );   % ����Ȩrho��S��ͼ
        
        %%%%%%%%%%greeks~tau
        [hfig] = plot_gamma_tau( self );    % ����Ȩgamma��tau��ͼ
        [hfig] = plot_vega_tau( self );     % ����Ȩvega��tau��ͼ
        [hfig] = plot_theta_tau( self );    % ����Ȩtheta��tau��ͼ
        [hfig] = plot_rho_tau( self );      % ����Ȩrho��tau��ͼ
        
        [ hfig ] = plot_gamma_tau_mix( obj );
        [ hfig ] = plot_delta_tau_mix( obj );
        [ hfig ] = plot_rho_tau_mix( obj );
        [ hfig ] = plot_theta_tau_mix( obj );

        %%%%%%%%%%greeks~K
        [hfig] = plot_gamma_K( self ); % ����Ȩgamma��K��ͼ
        [hfig] = plot_vega_K( self );  % ����Ȩvega��J��ͼ
        [hfig] = plot_theta_K( self ); % ����Ȩtheta��J��ͼ
        [hfig] = plot_rho_K( self );   % ����Ȩrho��J��ͼ
        
        %%%%%%%%%% ������4��ͼ
        [ hfig ] = plot_px_delta_gamma_S( self ); % ��px~S,delta~S,gamma~S��һ��
        [ hfig ] = plot_px_rho_R( self );         % ��px~R��rho~S��һ��
        [ hfig ] = plot_px_vega_sigma( self );    % ��px~sigma,vega~sigma��һ��
        [ hfig ] = plot_px_theta_tau( self );     % ��px~tau,theta~S��һ��
        
    end
    
    %% static����
    methods(Access = 'public', Static = true, Hidden = false)
        % һ������OptInfoΪ������Demo
        demo;
        % һ������OptPricer����֤��ͼ��volsurface��Demo
        demo2;
        % ��positionArrayת����structure��������
        demo3;
    end
    
end

