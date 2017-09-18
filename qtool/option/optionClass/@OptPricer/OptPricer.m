classdef OptPricer < OptInfo
%OPTPRICER �������ۼ�����Ȩ�۸�Ŀǰֻʹ��BS����
%calcIntrinsicValue��Ҫ����K��S����
%calcMoneyness��Ҫ����S��K����
%calcPx��Ҫ����S|K|r|tau|sigma( tau��ҪT��currentDate���� )����
%calcTimeValue��Ҫ����S|K|r|tau|sigma( tau��ҪT��currentDate���� )����
%calcDelta��Ҫ����S|K|r|tau|sigma( tau��ҪT��currentDate���� )����
%calcGamma��Ҫ����S|K|r|tau|sigma( tau��ҪT��currentDate���� )����
%calcTheta��Ҫ����S|K|r|tau|sigma( tau��ҪT��currentDate���� )����
%calcRho��Ҫ����S|K|r|tau|sigma( tau��ҪT��currentDate���� )����
% -------------------------------------------------------------
% �̸գ�2060124, д��demo
% [hfig] = plot_optprice_S(obj); % ����Ȩ�۸��S��ͼ
% [hfig] = plot_delta_S(obj); % ����Ȩdelta��S��ͼ
% TODO��[�ο������] ���calcGamma�� calcVega�� calcTheta��calcRho
% TODO��[�ο������] ѧϰdemo����ɸ��ֻ�ͼ����
% �̸գ�20160124�������˸��ƹ��캯��
% ���Ʒ壬20160129���޸���������ͼ������������ע��
% �̸գ�20160202����дM���ԣ�Dependent=true�� ��get.M������û��set.M(����set�� ���ܸ�ֵ��
% ���Ʒ壬20160217���¼Ӽ��㱣֤��Ĺ�ʽ
% ���Ʒ壬20160229������һ��init_from_sse_excel�ķ���
% ���Ʒ� 20170524 Ϊ���ܹ���ȡ��Ʒ��Ȩ��ԼOptCommodityInfo���޸���init_from_sse_excel��BUG
 
    properties
 
        % ��Щ�Ǵ�OptInfo�̳еı���        
        % code = 10000000;        % ��Ȩ����,��ͬ 10000283,��ֵ��
        % optName = '������Ȩ';    % ��ͬ '50ETF3�¹�2200',�ַ���
        % underCode = 510050;     % ��Ĵ���,��ͬ 510050,��ֵ��
        % CP = 'call';            % 'C', 'c', 'Call', 'call', 'CALL' OR 'P', 'p', 'put', 'Put', 'PUT'
        % K = 0;                  % ��Ȩִ�м۸�
        % T;                      % ��Ȩ����ʱ��,��ֵ�����ڣ���datenum('2016-1-27')
        % multiplier = 10000;     % ��Լ����
        % currentDate;            % ��������,��ֵ�����ڣ��� today
        % tau = 0;                % �껯ʣ��ʱ��, (T - currentDate)/365
        % ST;                     % ���ڼ۸�
        % payoff;                 % ��Ȩ�ĵ��ڻر�
        
        % �������
        sigma = 0.3;              % ������(����Ĳ�����Ҫ����VolSurfaceȥ��ȡ)
        S = 2;                    % underlier�ĵ�ǰ�۸�
        r = 0.05;                 % �޷�������               
        model = 'BS';             % ʹ�õ�ģ�ͣ���ʱû������
        
        % ������
        intrinsicValue;           % ���ڼ�ֵ�� ��S-K)+ �� ��K-S)+
        timeValue;                % ʱ���ֵ
        px;                       % ��Ȩ�۸�
        
        % greeks
        delta;
        gamma;
        vega;
        theta;
        rho;     
        
    end
    
    properties(Dependent = true, Hidden = true)
        % moneyness�� S/K �� ln(S/K)
        M;                        
    end
    
    %% ����ķ���
    methods
        
        function mg = margin( self )
            % ���ֱ�֤��
            % ��ͱ�׼
            % �Ϲ���Ȩ����ֿ��ֱ�֤��[��Լǰ�����+Max��12%����Լ���ǰ���̼�-�Ϲ���Ȩ��ֵ��7%����Լ���ǰ���̼ۣ�] ����Լ��λ
            % �Ϲ���Ȩ����ֿ��ֱ�֤��Min[��Լǰ�����+Max��12%����Լ���ǰ���̼�-�Ϲ���Ȩ��ֵ��7%����Ȩ�۸񣩣���Ȩ�۸�] ����Լ��λ
            % ά�ֱ�֤��
            % ��ͱ�׼
            % �Ϲ���Ȩ�����ά�ֱ�֤��[��Լ�����+Max��12%����Լ������̼�-�Ϲ���Ȩ��ֵ��7%����Լ������̼ۣ�]����Լ��λ
            % �Ϲ���Ȩ�����ά�ֱ�֤��Min[��Լ����� +Max��12%���ϱ�����̼�-�Ϲ���Ȩ��ֵ��7%����Ȩ�۸񣩣���Ȩ�۸�]����Լ��λ
            % ���У��Ϲ���Ȩ��ֵ=Max����Ȩ��-��Լ������̼ۣ�0��
            % �Ϲ���Ȩ��ֵ=max����Լ������̼�-��Ȩ�ۣ�0��
            self.calcIntrinsicValue;
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL', '�Ϲ�', '��',1 }
                    mg = self.px + max( self.S*0.12 - self.intrinsicValue, self.S *0.07 );
                case {'P', 'p', 'put', 'Put', 'PUT', '�Ϲ�',  '��', 2}
                    mg = min( self.px + max( self.S*0.12 - self.intrinsicValue,  self.K*0.07 ), self.K );                    
            end
            
        end
        
        % ����intrinsic value
        function [inValue] = calcIntrinsicValue( self )
            % ����Ҫ������K��S
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
            % ����Ȩ����
%             self.calcTau; 
            if(isnan(self.sigma))
                self.px = 0.001;
                return;
            end
            switch self.model
                case {'BS'}
                    [call, put] = blsprice(self.S, self.K, self.r, self.tau, self.sigma, 0);
                otherwise
                    error('δ֪ģ��');
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
            % ����Ȩ��ʱ���ֵ
            self.calcPx;
            self.calcIntrinsicValue;
            timeValue = self.px - self.intrinsicValue;
            self.timeValue = timeValue;            
        end
       
%% ------------------Greeks--------------------------    
      
        function [delta] = calcDelta(self)
            % ����Ȩ��delta
            [cDelta, pDelta] = blsdelta(self.S, self.K, self.r, self.tau, self.sigma, 0);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    delta = cDelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    delta = pDelta;
            end
            self.delta = delta;
        end
        
 %%%%%%%%%%%%%%%%%%%%%%%%������ϣ����ĸ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
 
       % ������Ȩ��Gamma�����
       function [gamma] = calcGamma(self)
           % ����Ȩ��Gamma,Call��Put��Gamma��һ����
            gamma = blsgamma(self.S, self.K, self.r, self.tau, self.sigma, 0);          
            self.gamma = gamma;
       end
       
       % ����Ȩ��Vega,Call��Put��Vega��һ����
       function [vega] = calcVega(self)  
           vega = blsvega(self.S, self.K, self.r, self.tau, self.sigma, 0);          
           self.vega = vega;
       end
       
        % ����Ȩ��theta
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
            % ����Ȩ��rho
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
     
    %% ����͵ķ���
    
    % ����ķ��������ͼ���ġ�word�ĵ���

    methods(Access = 'public', Static = false, Hidden = false)
        
        [hfig] = plot_optprice_S(obj); % ����Ȩ�۸��S��ͼ
        [hfig] = plot_optprice_tau(obj); % ����Ȩ�۸��tau��ͼ
        [hfig] = plot_optprice_r(obj); % ����Ȩ�۸��r��ͼ
        [hfig] = plot_optprice_sigma(obj); % ����Ȩ�۸��sigma��ͼ
        [hfig] = plot_delta_S(obj); % ����Ȩdelta��S��ͼ   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%����
        
        %%%%%%%%%%���ӵ�ϣ����ĸ
        [hfig] = plot_gamma_S(obj); % ����Ȩgamma��S��ͼ
        [hfig] = plot_vega_S(obj); % ����Ȩvega��S��ͼ
        [hfig] = plot_theta_S(obj); % ����Ȩtheta��S��ͼ
        [hfig] = plot_rho_S(obj); % ����Ȩrho��S��ͼ
        
        %%%%%%%%%%greeks~tau
        [hfig] = plot_gamma_tau(obj); % ����Ȩgamma��tau��ͼ
        [hfig] = plot_vega_tau(obj); % ����Ȩvega��tau��ͼ
        [hfig] = plot_theta_tau(obj); % ����Ȩtheta��tau��ͼ
        [hfig] = plot_rho_tau(obj); % ����Ȩrho��tau��ͼ

        %%%%%%%%%%greeks~K
        [hfig] = plot_gamma_K(obj); % ����Ȩgamma��K��ͼ
        [hfig] = plot_vega_K(obj); % ����Ȩvega��K��ͼ
        [hfig] = plot_theta_K(obj); % ����Ȩtheta��K��ͼ
        [hfig] = plot_rho_K(obj); % ����Ȩrho��K��ͼ
        
        %%%%%%%%%%greeks~sigma
        [hfig] = plot_gamma_sigma(obj); % ����Ȩgamma��K��ͼ
        [hfig] = plot_vega_sigma(obj); % ����Ȩvega��K��ͼ
        [hfig] = plot_theta_sigma(obj); % ����Ȩtheta��K��ͼ
        [hfig] = plot_rho_sigma(obj); % ����Ȩrho��K��ͼ
        
        %%%%%%%%%% ������4��ͼ
        [ hfig ] = plot_px_delta_gamma_S(obj); % ��px~S,delta~S,gamma~S��һ��
        [ hfig ] = plot_px_rho_R( obj ); % ��px~R��rho~S��һ��
        [ hfig ] = plot_px_vega_sigma( obj);%��px~sigma,vega~sigma��һ��
        [ hfig ] = plot_px_theta_tau( obj );%��px~tau,theta~S��һ��
        
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         [ hfig ] = plot_delta_tau_mix( obj );
         [ hfig ] = plot_rho_tau_mix( obj );
         [ hfig ] = plot_theta_tau_mix( obj );
    end
    
    %% static�ķ���
    methods( Static = true )
        
        % �����������о�
        demo_plot;
        demo2; 
        demo3;
        % ������һ��Pricer��Excel�����ȡ�ķ���
        [ pricer , m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( optInfoxlsx );
        
    end
    
    %% ���ƹ��캯��
    methods(Hidden = false)
        
        % ���ƹ��캯��
        [ newobj ] = getCopy( obj );
        
    end
    
end

