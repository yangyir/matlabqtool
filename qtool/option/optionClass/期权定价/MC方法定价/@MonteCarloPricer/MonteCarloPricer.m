classdef MonteCarloPricer < handle
    %MonteCarloPricer 是使用MonteCarlo方法的定价工具
    % 使用于任何期权，vanilla和exotique都可以，给payoff公式就行
    % ------------------------
    % 朱江，20160219
    % 程刚，20160221，改名rfr，加入set方法
    % 程刚，20160223，改写calc_opt_price，适用于S只是一条路径，加demo1，改名demo2，demo3
    
    properties
        model = BlackScholesModel;  
        SgeneratorHandler;      % 生成Ｓ序列的函数
        payoffFunctionHandler;  % 计算payoff（S）的函数 
        
        % M.C.方法的变量
        iterN@double = 100000;    
        
        % 环境变量, 折现用
        rfr@double = 0.05;
        
    end
    
    methods
%         function [obj] = MonterCarloPricer(Model)%, PayoffCalcular)
%             %构造函数
%             % Pricer构造需要Model 和 payoff
%             % Model是一个对象，PayoffCalcular也是个对象，其中约定，Model提供
%             % generate_S_from_model 方法，该方法返回一个S矩阵
%             % PayoffCalcular是计算器对象，约定任何类型的PayoffCalcular对象
%             % 都提供计算payoff方法：calc_MC_payoff;
%             if ~exist('Model', 'var') 
%                 Model = BlackScholesModel;
%             end
%             
%             obj.model = Model;
% %             obj.SgeneratorHandler = @Model.generate_S_from_model;
% %             obj.payoffFunctionHandler = @PayoffCalcular.calc_MC_payoff;
%         end;
        
        function obj = set.model(obj, m ) 
            obj.model = m;
            obj.SgeneratorHandler = @m.generate_S_from_model;
        end
        
        function obj = set.rfr( obj, r)
            obj.rfr = r;
            try  % 试：改model里的rfr，如果model里没有这个，就算了
                obj.model.rfr = r;
            end
        end
                
    end
    
    methods
%         function [p] = calc_payoff(obj)
%             fun = obj.SgeneratorHandler;
%             S   = fun(obj.iterN);
%             fun = obj.payoffFunctionHandler;
%             p   = fun(S);
%         end
        
        function [price] = calc_opt_price(obj)
            % 适用于一条一条路径模拟，每次生成一条路径，算一次payoff
            p = zeros(obj.iterN, 1);
            fun_s = obj.SgeneratorHandler;
            fun_p = obj.payoffFunctionHandler;
            for i = 1:obj.iterN
                S       = fun_s();     % 生成单一一条路径 S
                p(i)    = fun_p(S);    % 算单一一个payoff              
            end
            price_T = nanmean(p);
            
            % 折现
            [~, T] = size(S);
            price_now = exp(-obj.rfr * T / 365) * price_T;
            price = price_now;
        end

        function [price] = calc_opt_price_mat(obj)
            % 适用于S矩阵路径，一次全部模拟好，payoff一次全算好，效率高
            fun = obj.SgeneratorHandler;
            S   = fun(obj.iterN);
            fun = obj.payoffFunctionHandler;
            p   = fun(S);
            price_T = nanmean(p);
            
           %% 折现
            [~, T] = size(S);
            r = obj.rfr;
            price_now = exp(- r * T / 365) * price_T;
            price = price_now;
        end
            
    
        
        
        function [txt] = println(obj)
            txt = '';
            c   = class(obj);
            txt = sprintf('[%s] rfr=%0.2f%%, (%d)\n',...
                c, obj.rfr*100, obj.iterN);
            
            if nargout == 0;
                disp(txt);
            end
        end
        
    
    end
    
    
    %%
    methods(Static = true )
        demo1
        demo2
        demo3
    end
    
end

