classdef MonteCarloPricer < handle
    %MonteCarloPricer ��ʹ��MonteCarlo�����Ķ��۹���
    % ʹ�����κ���Ȩ��vanilla��exotique�����ԣ���payoff��ʽ����
    % ------------------------
    % �콭��20160219
    % �̸գ�20160221������rfr������set����
    % �̸գ�20160223����дcalc_opt_price��������Sֻ��һ��·������demo1������demo2��demo3
    
    properties
        model = BlackScholesModel;  
        SgeneratorHandler;      % ���ɣ����еĺ���
        payoffFunctionHandler;  % ����payoff��S���ĺ��� 
        
        % M.C.�����ı���
        iterN@double = 100000;    
        
        % ��������, ������
        rfr@double = 0.05;
        
    end
    
    methods
%         function [obj] = MonterCarloPricer(Model)%, PayoffCalcular)
%             %���캯��
%             % Pricer������ҪModel �� payoff
%             % Model��һ������PayoffCalcularҲ�Ǹ���������Լ����Model�ṩ
%             % generate_S_from_model �������÷�������һ��S����
%             % PayoffCalcular�Ǽ���������Լ���κ����͵�PayoffCalcular����
%             % ���ṩ����payoff������calc_MC_payoff;
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
            try  % �ԣ���model���rfr�����model��û�������������
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
            % ������һ��һ��·��ģ�⣬ÿ������һ��·������һ��payoff
            p = zeros(obj.iterN, 1);
            fun_s = obj.SgeneratorHandler;
            fun_p = obj.payoffFunctionHandler;
            for i = 1:obj.iterN
                S       = fun_s();     % ���ɵ�һһ��·�� S
                p(i)    = fun_p(S);    % �㵥һһ��payoff              
            end
            price_T = nanmean(p);
            
            % ����
            [~, T] = size(S);
            price_now = exp(-obj.rfr * T / 365) * price_T;
            price = price_now;
        end

        function [price] = calc_opt_price_mat(obj)
            % ������S����·����һ��ȫ��ģ��ã�payoffһ��ȫ��ã�Ч�ʸ�
            fun = obj.SgeneratorHandler;
            S   = fun(obj.iterN);
            fun = obj.payoffFunctionHandler;
            p   = fun(S);
            price_T = nanmean(p);
            
           %% ����
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

