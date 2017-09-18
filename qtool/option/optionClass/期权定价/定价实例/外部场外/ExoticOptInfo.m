classdef( Hidden = false,Sealed = false ) ExoticOptInfo < handle
    %OPTINFO放期权的固定信息，通常只放一个，也可放多个
    %计算函数calcPayoff和calcTau既可以针对OptInfo也可以针对OptPricer
    %calcPayoff需要变量K和ST计算
    %calcTau需要变量T和currentDate计算
    % ---------------------------------------------------------------------
    % 吴云峰，20160120
    % 吴云峰，20160120，增加了一个实时更新的期权价格px和一个计算到期收益的函数calcReturn
    % chenggang,20160121, 增加static方法init_from_sse_excel()
    % 程刚，20160124，增加static方法demo()
    % 程刚，20160124，改变了calcPayoff(ST)，使能够接受数组的ST
    % 程刚，20160124，增加了复制构造函数getCopy
    % 程刚，20160202，增加properties中 @class 用法，限制数据类型
    % 程刚，20160208，加入set.T, 适应不同数据类型, char, cell(char), double
    % 程刚，20160211，加入set.CP, 只有两个值'call', 'put'
    % 程刚，20160217，约定：所有code都是用char，以避免混乱
    
    properties(Access = public,Hidden = false)  
        
        % 常数信息
        code        = '00000000';  % (@char,setter控制) 期权代码,形同 '10000283'
        optName@char = '无名期权';  % 形同 '50ETF3月购2200',字符串
        T;                      % (@double，setter控制)可接受string
        multiplier = 10000;     % 合约乘数
        
        % 未必放进来的变量
        currentDate@double = today;           % 今天日期,数值型日期，即 today
        tau = 0;               % 年化剩余时间, (T - currentDate)/365
        ST;                    % 到期价格
        payoff;                % 期权的到期回报
                
    end
    
    %% 构造函数，拷贝构造函数，隐藏？
    
    methods(Hidden = true)
        
        % 构造函数
        function obj = ExoticOptInfo()     
            obj.currentDate = today;
        end
        
        % 复制构造函数
        function new = copy(obj)
            % copy() is for deep copy case.
            new = feval(class(obj));
            % copy all non-hidden properties
            p = properties(obj);
            for i = 1:length(p)
                new.(p{i}) = obj.(p{i});
            end
        end        
    end
    
    methods
        
        % T需要一个setter，可以识别string
        function [ obj ] = set.T(obj, value )
            % T需要一个setter，可以识别string

            if isa(value, 'cell')
                [L1, L2] = size(value);
                dn = zeros(L1,L2);
                for i = 1:L1
                    for j = 1:L2
                        dn(i,j) = datenum( value{i,j} );
                    end
                end
            end
            if isa(value, 'char') 
                dn = datenum(value);
            end
            
            if isa(value, 'double')
                dn = value;
            end
            
            obj.T = dn;
            
        end
        
        
        % 强制类型转换：所有code都是char
        function [obj] = set.code(obj, vin)
            % 强制类型转换：所有code都是char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);                        
            switch cl
                case {'double' }
%                     disp('强制类型转换：optinfo.code应为char');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('赋值失败：optinfo.code应为char');
                    return;
            end
            obj.code = vout;
        end
        
    end

    
    
    %% 其他函数
    
    methods(Access = 'public', Static = false, Hidden = false)
        
        function fillOptInfo( self, code, optName,T, CP)            
            % 填入期权信息
            self.code = code;
            self.optName = optName;
            self.underCode = underCode;
            self.T = T;
            self.K = K;
            self.CP = CP;   
            
            self.calcTau;            
        end
        
        % 基于到期价格计算(算到期日的payoff)
        function [ payoff ] = calcPayoff(obj, ST )            
            % 基于到期价格计算(算到期日的payoff)
            if ~exist('ST', 'var'), 
                ST = obj.ST; 
            else
                obj.ST = ST;
            end
            
            switch obj.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    payoff = max( ST - obj.K, zeros(size(ST)) );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    payoff = max( obj.K - ST, zeros(size(ST))  );
             end   
            
             obj.payoff = payoff;             
        end
        
        % 专门用于MonteCarloPricer的payoff函数
        function [payoff] = calcMCpayoff( obj, S)
            ST = S(:,end);
            switch obj.CP
                case {'call'}
                    payoff = max( ST - obj.K, 0 );
                case { 'put' }
                    payoff = max( obj.K - ST, 0  );
            end
        end
        
        % 计算tau 
        function [tau] = calcTau(obj, thisdate)            
            % 计算tau            
            if ~exist('thisdate', 'var') 
                thisdate = obj.currentDate;
            else
                obj.currentDate = thisdate;
            end
            
            % TODO：要检验和防错，涉及日期，str，double
            tau = ( obj.T - thisdate + 1 )/365;
            obj.tau = tau;
        end
        
        % 期权输出信息(短字符串)
        function [s] = infoShortstr(obj)
            
            % 形同：call[0.34, 2.2]         
            s = sprintf('%s{%0.2fy, %0.0f}', obj.CP, obj.tau, obj.K);
            
        end
        
        % 期权输出信息(长字符串)
        function [s] = infoLongstr(obj)
            
            % 形同： 10000239,50ETF3月购2200,call(510050),T=2016-03-12, K=2.3
            s = sprintf('%s,%s,T=%s', obj.code, obj.optName,datestr(obj.T));
            
        end
     
    end
    
end


