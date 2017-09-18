classdef BlackScholesModel < handle
    % BlackScholesModel类 约定实现generate_S_from_model(obj, iterN) 方法
    % 为外部使用者按BlackScholes模型生成 S 矩阵。    
    % ___________________________
    % 朱江 2016.2.19
    % 程刚，20160221，改名rfr（TODO：是否删除？）
    
    properties
        % 模型的参数
        sigma@double = 0.3;
        mu@double;
        rfr@double = 0.03;
        
        % 生成S的矩阵， iterN * stepT
        iterN@double = 1;  % 单路径版
        stepT@double ;
    end
    
    methods
%         function [obj] = BlackScholesModel()
%         end
    end    
    
    methods
        function [obj] = set_params_from_optPricer( obj, opt )
            % 从OptInfo里提取信息，放入model
            if isa(opt, 'OptInfo')
                %option_info 内包含有到期日,sigma, risk free rate 等信息
                obj.stepT = opt.T - opt.currentDate;
                obj.sigma = opt.sigma;
            elseif isa(opt, 'ExoticOptInfo')
                obj.stepT = opt.T;
                obj.sigma = opt.sigma;
            end
        end
        
        
        % TODO：这里是权宜之策，让 mu = rfr， 如不欲，就重新写mu，但是要在rfr之后赋值
        function obj = set.rfr( obj, value )
            obj.rfr = value;
            obj.mu = value;
        end


        function [S] = generate_S_from_model(obj, iterN)
            % 核心方法：
            % 生成S矩阵：iterN * stepT。            
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
    
    
    
    %% BlackScholes 模型的 MonterCarlo 方法
    methods (Access = private)
        function [S] = BlackScholesModel_method_1(obj, stepT,iterN, sigma, mu)
          %% 方法一：
            %  dS = S(mu * dt + sigma * dB(t))
            %  取 mu = rfr
            %  Delta(S(i+1)) = S(i) * (mu * Delta(t) + sigma * Delta(B(t)))
            %  Delta(t) = 1/365 用年为单位来表示一天的变化
            %  Delta(B) = N(0,1) * 1/((365)^(1/2))
            %  S(0) + Delta(S(1)) -> S(1) ... 一直表达到S(T) 得出从S(0)到S(T)的Array
            
          %% 方法一蒙特卡洛实现：
            S0 = 1;
            S = zeros(iterN, stepT);
            delta_t = 1/365;
            sqrt_t = sqrt(delta_t);
            N = normrnd(0,1,[iterN,stepT]); % 生成正态分布随机数矩阵 iterN * stepT
            
            delta_B = sqrt_t .* N; % 正态分布的deltaB
            
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
            %%方法二：
            % S(t) = S(0) * exp(sigma * B(t) + (mu - (sigma^2)/2) * t)
            % 通常取mu = rfr
            % B(t) ~ N(0,1) * t^(1/2).  其中 t = T/365
            % N(1),...,N(T)
            % B(i) = 从1到i，对 N(0,1)* 1 / (365^1/2)求和
            % 从B(i)可以得出S(i)， 此即为所求序列。
            S0 = 1;
            S = zeros(iterN, stepT);
            delta_t = 1/365;
            sqrt_t = sqrt(delta_t);
            N = normrnd(0,1,[iterN,stepT]); % 生成正态分布随机数矩阵 iterN * stepT
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





  


