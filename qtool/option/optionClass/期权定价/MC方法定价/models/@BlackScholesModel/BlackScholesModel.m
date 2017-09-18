classdef BlackScholesModel < handle
    % BlackScholesModel�� Լ��ʵ��generate_S_from_model(obj, iterN) ����
    % Ϊ�ⲿʹ���߰�BlackScholesģ������ S ����    
    % ___________________________
    % �콭 2016.2.19
    % �̸գ�20160221������rfr��TODO���Ƿ�ɾ������
    
    properties
        % ģ�͵Ĳ���
        sigma@double = 0.3;
        mu@double;
        rfr@double = 0.03;
        
        % ����S�ľ��� iterN * stepT
        iterN@double = 1;  % ��·����
        stepT@double ;
    end
    
    methods
%         function [obj] = BlackScholesModel()
%         end
    end    
    
    methods
        function [obj] = set_params_from_optPricer( obj, opt )
            % ��OptInfo����ȡ��Ϣ������model
            if isa(opt, 'OptInfo')
                %option_info �ڰ����е�����,sigma, risk free rate ����Ϣ
                obj.stepT = opt.T - opt.currentDate;
                obj.sigma = opt.sigma;
            elseif isa(opt, 'ExoticOptInfo')
                obj.stepT = opt.T;
                obj.sigma = opt.sigma;
            end
        end
        
        
        % TODO��������Ȩ��֮�ߣ��� mu = rfr�� �粻����������дmu������Ҫ��rfr֮��ֵ
        function obj = set.rfr( obj, value )
            obj.rfr = value;
            obj.mu = value;
        end


        function [S] = generate_S_from_model(obj, iterN)
            % ���ķ�����
            % ����S����iterN * stepT��            
            if ~exist('iterN', 'var')
                iterN = obj.iterN;
            end
            S = obj.BlackScholesModel_method_2(obj.stepT, iterN, obj.sigma, obj.mu);
        end
        
        
        function [txt ] =  println(obj)
            txt = '';
            c   = class(obj);
            txt = sprintf('[%s] mu=%0.2f, rfr=%0.2f%%, sigma=%0.2f%% (%d*%d)\n',...
                c, obj.mu, obj.rfr*100, obj.sigma*100, obj.iterN, obj.stepT);
            
            if nargout == 0;
                disp(txt);
            end
        end
    end
    
    
    
    %% BlackScholes ģ�͵� MonterCarlo ����
    methods (Access = private)
        function [S] = BlackScholesModel_method_1(obj, stepT,iterN, sigma, mu)
          %% ����һ��
            %  dS = S(mu * dt + sigma * dB(t))
            %  ȡ mu = rfr
            %  Delta(S(i+1)) = S(i) * (mu * Delta(t) + sigma * Delta(B(t)))
            %  Delta(t) = 1/365 ����Ϊ��λ����ʾһ��ı仯
            %  Delta(B) = N(0,1) * 1/((365)^(1/2))
            %  S(0) + Delta(S(1)) -> S(1) ... һֱ��ﵽS(T) �ó���S(0)��S(T)��Array
            
          %% ����һ���ؿ���ʵ�֣�
            S0 = 1;
            S = zeros(iterN, stepT);
            delta_t = 1/365;
            sqrt_t = sqrt(delta_t);
            N = normrnd(0,1,[iterN,stepT]); % ������̬�ֲ���������� iterN * stepT
            
            delta_B = sqrt_t .* N; % ��̬�ֲ���deltaB
            
            for i = 1:iterN % loop Rows
                delta_S1 = S0 * (mu * delta_t + sigma * delta_B(i,1));
                S(i, 1) = S0 + delta_S1;
                for j = 2:stepT %loop Columns
                    delta_S =  S(i,j - 1) * (mu * delta_t + sigma * delta_B(i,j));
                    S(i,j) = S(i,j-1) + delta_S;
                end
            end
        end;
        
        function [S] = BlackScholesModel_method_2(obj, stepT,iterN, sigma, mu)
            %%��������
            % S(t) = S(0) * exp(sigma * B(t) + (mu - (sigma^2)/2) * t)
            % ͨ��ȡmu = rfr
            % B(t) ~ N(0,1) * t^(1/2).  ���� t = T/365
            % N(1),...,N(T)
            % B(i) = ��1��i���� N(0,1)* 1 / (365^1/2)���
            % ��B(i)���Եó�S(i)�� �˼�Ϊ�������С�
            S0 = 1;
            S = zeros(iterN, stepT);
            delta_t = 1/365;
            sqrt_t = sqrt(delta_t);
            N = normrnd(0,1,[iterN,stepT]); % ������̬�ֲ���������� iterN * stepT
            NT = sqrt_t * N;
            B = cumsum(NT,2);
            
            for j = 1 : stepT
                t = j / 365;
                S(:,j) = S0 * exp(sigma * B(:,j) + (mu - 0.5 * sigma^2) * t);
            end
        end
              
    end
    
    

    
    
    methods(Static = true)
        demo;
    end
    
end





  


