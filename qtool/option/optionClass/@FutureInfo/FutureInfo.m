classdef( Hidden = false,Sealed = false ) FutureInfo < handle
    %FutureInfo放期货的固定信息，通常只放一个，也可放多个
    %calcTau需要变量T和currentDate计算
    % ---------------------------------------------------------------------
    % 朱江， 20160304, first issue
    
    properties(Access = public,Hidden = false)  
        % 常数信息
        code        = '000000';  % (@char,setter控制) 期货代码,形同 '10000283'
        futureName@char = '无名期货';  % 形同 'IH1603',字符串
        T = today + 100;            % (@double，setter控制)可接受string
        multiplier = 1;     % 合约乘数
        
        % 今天日期,数值型日期，即 today
        currentDate@double = today;           
        tau = 0;               % 年化剩余时间, (T - currentDate)/365
    end
    
    %% 构造函数，拷贝构造函数，隐藏？
    methods(Hidden = true)
        
        % 构造函数
        function obj = FutureInfo()     
            obj.currentDate = today;
        end
        
        % 复制构造函数
        [ newobj ] = getCopy(obj);      
        
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
            
            % 触发tau的更新
            obj.calcTau;            
        end
        
        % 设置日期起点时，自动更新tau
        function obj = set.currentDate(obj, value )
            obj.currentDate = value;
            % 触发tau的更新
            obj.calcTau;            
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
        
        function fillFutureInfo( self, code, futureName, T)            
            % 填入期权信息
            self.code = code;
            self.futureName = futureName;
            self.T = T;               
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
      
        % 期权输出信息(长字符串)
        function [s] = infoLongstr(obj)
            
            % 形同： 10000239,50ETF3月购2200,call(510050),T=2016-03-12, K=2.3
            s = sprintf('%s,%s,T=%s', obj.code, obj.futureName,...
                datestr(obj.T));            
        end
     
    end
    
%% ---------------------static 方法----------------------

    methods(Access = 'public', Static = true, Hidden = false)
    end
    
end


