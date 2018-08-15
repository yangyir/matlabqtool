classdef( Hidden = false,Sealed = false ) OptInfo < handle
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
    % 程刚，20160302，修改和增加setter，使T、currentDate变动时，触发tau的更新
    % 朱江，20160320, 去掉变动T和currentDate时触发tau计算,分开计算隔日和日内时间tau。
    % cg，161017，加入iT，iK， 用于反身索引
    % 朱江，20161226, 加入getName()方法，各种Quote类型保持一致方法。
    % 吴云峰 20161229 加入获取特征合约代码 [stockCode, startDate] = fetchOptCodeByFeature(CP, strike, ExpireDate);
    % 吴云峰 20170524 为了能够读取商品期权合约OptCommodityInfo，修改了init_from_sse_excel的BUG
    % 吴云峰 20170613 增加合约是否为分红前的合约is_pre_dividend，[flag] = is_pre_dividend(obj)
    % 程刚，20170708， 把is_pre_dividend() 代码放入类代码
    
    
    properties(Access = public,Hidden = false)  
        % 常数信息
        code        = '00000000';   % (@char,setter控制) 期权代码,形同 '10000283'
        optName@char = '无名期权';   % 形同 '50ETF3月购2200',字符串
        underCode   = '510050';     % (@char,setter控制)标的代码,形同 '510050'
        CP@char = 'call';           %（'call'或'put'，setter控制）, 可接受'C', 'c', 'Call', 'call', 'CALL' OR 'P', 'p', 'put', 'Put', 'PUT'
        K@double = 2;               % 期权执行价格
        T = today + 100;            % (@double，setter控制)可接受string
        multiplier = 10000;         % 合约乘数
        
        % 未必放进来的变量
        % 今天日期,数值型日期，即 today
        currentDate@double = today;           
        tau = 0;               % 年化剩余时间, (T - currentDate)/365
        ST;                    % 到期价格
        payoff;                % 期权的到期回报

%%-----------------------------做成隐藏变量？-----------------------------%%
        iT@double = 0;                   % 在M2TK中的位置，用于反索引
        iK@double = 0;                   % 在M2TK种的位置，用于反索引   
%%-----------------------------未必放进来-----------------------------%%
%         S;                     % 标的价格，实时更新
%         M;                     % Moneyness; % (S/K)  或 ln(S/K)
%%-----------------------------未必放进来-----------------------------%%
        
%%-----------------------------未必放进来-----------------------------%%
%         num;                   % 合约的数目
%         px;                    % 期权的价格，实时更新
%%-----------------------------未必放进来-----------------------------%% 
    end
    
    %% 构造函数，拷贝构造函数，隐藏？
    
    methods(Hidden = true)
        
        % 构造函数
        function obj = OptInfo()     
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
        end
              
        % 设置日期起点时，自动更新tau
        function obj = set.currentDate(obj, value )
            obj.currentDate = value;
        end
        
        % 只有'call', 'put'
        function [obj] = set.CP(obj, value)
            switch value
                case {'C', 'c', 'Call', 'call', 'CALL', '认购', '购',1 }
                    obj.CP = 'call';
                case {'P', 'p', 'put', 'Put', 'PUT', '认沽',  '沽', 2}
                    obj.CP = 'put';
            end
        end
        
        % 强制类型转换：所有code都是char
        function [obj] = set.code(obj, vin)
            % 强制类型转换：所有code都是char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);                        
            switch cl
                case {'double' }
                   % disp('强制类型转换：optinfo.code应为char');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('赋值失败：optinfo.code应为char');
                    return;
            end
            obj.code = vout;
        end
        
        % 强制类型转换：所有code都是char
        function [obj] = set.underCode(obj, vin)
            % 强制类型转换：所有code都是char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);
            switch cl
                case {'double' }
                    % disp('强制类型转换：optinfo.underCode应为char');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('赋值失败：optinfo.underCode应为char');
                    return;
            end
            obj.underCode = vout;
        end
       % 强制类型转换：所有code都是char
        function [obj] = set.optName(obj, vin)
            % 强制类型转换：所有code都是char
            if iscell(vin), vin = vin{1}; end
            
            cl = class(vin);
            switch cl
                case {'double' }
                    % disp('强制类型转换：optinfo.underCode应为char');
                    vout = num2str(vin);                    
                case {'char'}
                    vout = vin;
                otherwise
                    warning('赋值失败：optinfo.underCode应为char');
                    return;
            end
            obj.optName = vout;
        end
        % Get各属性方法
        function [name] = getName(obj)
            name = obj.optName;
        end
    end

    
    %% 其他函数
    
    methods(Access = 'public', Static = false, Hidden = false)
        function [valid] = is_valid_opt(obj)
            % 判断是否是有意义的Opt
            % [valid] = is_valid_opt()
            % optName@char = '无名期权';
            valid = ~strcmp(obj.optName, '无名期权');
        end
        
        function fillOptInfo( self, code, optName,underCode, T, K, CP)            
            % 填入期权信息
            self.code = code;
            self.optName = optName;
            self.underCode = underCode;
            self.T = T;
            self.K = K;
            self.CP = CP;   

%             self.calcTau;            
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
        
        % 计算tau:高精度计算到期日
        function [tau] = calcTau(obj, thisdate, calc_type)
            if ~exist('thisdate', 'var')
                thisdate = obj.currentDate;
            else
                obj.currentDate = thisdate;
            end
            
            if ~exist('calc_type', 'var')
                calc_type = 'trading';
            end
            % 计算tau
            % tau = (datenum(obj.T) - datenum(thisdate)) / 365;
            switch calc_type
                case 'trading'
                    tau = obj.calcTradingTau(thisdate);
                case 'nature'
                    tau = obj.calcNatureTau(thisdate);
                otherwise
                    tau = obj.calcTradingTau(thisdate);
            end
            
            obj.tau = tau;
        end
        
        function [tau_trad] = calcTradingTau(obj, thisdatetime)
            % 计算交易日，高精度，可以体现小时、分钟等。
            % 计算tau
            if ~exist('thisdate', 'var')
                thisdatetime = obj.currentDate;
            else
                obj.currentDate = thisdatetime;
            end
            ct_obj = Calendar_Test.GetInstance();
            tau_trad = ct_obj.trading_days_precise_annualised(thisdatetime, obj.T);
        end
        
        function [tau_nat] = calcTauNatureTau(obj, thisdatetime)
            % 计算自然日，高精度，可以体现小时、分钟等。
            if ~exist('thisdate', 'var')
                thisdatetime = obj.currentDate;
            else
                obj.currentDate = thisdatetime;
            end
            ct_obj = Calendar_Test.GetInstance();
            tau_nat = ct_obj.nature_days_precise_annualised(thisdatetime, obj.T);
        end
                
        % 期权输出信息(短字符串)
        function [s] = infoShortstr(obj)
            % 形同：call[0.34, 2.2]         
            s = sprintf('%s{%0.2fy, %0.0f}', obj.CP, obj.tau, obj.K);
        end
        
        % 期权输出信息(长字符串)
        function [s] = infoLongstr(obj)
            % 吴云峰，20160403，做了修改
            % 形同： 10000239,50ETF3月购2200,call(510050),T=2016-03-12, K=2.3
            % 10000605,50ETF购5月2250,call(510050),T=20160525, K=2.25
            s = sprintf('%s,%s,%s(%s),T=%s, K=%0.2f', obj.code, obj.optName,...
                obj.CP, obj.underCode, datestr(obj.T,'yyyymmdd'), obj.K);
        end
        
        % 判断合约是否为分红前的合约
        function [ flag ] = is_pre_dividend(obj)
            % 判断合约是否为分红前的合约
            %依据optName判断是否存在A
            % optName: '50ETF购1月2397A'
            
            flag    = false;
            optName = obj.optName;
            if optName(end) == 'A'
                flag = true;
            end
        end
        
        
    end
    
    %% 输入输出方法
    methods (Access = 'public')
        function [title] = to_excel_title(obj)
            flds = properties(obj);
            L = length(flds);
            for i = 1:L
                f = flds{i};
                title{i} = f;
            end
        end
        
        function [value_row] = to_excel_value(obj)
            flds = properties(obj);
            L = length(flds);
            for i = 1:L
                f = flds{i};
                value_row{i} = obj.(f);
            end
            
        end
        
        function [s] = println(obj)
            disp( obj.infoLongstr);
        end
    end
    
%% ---------------------static 方法----------------------

    methods(Access = 'public', Static = true, Hidden = false)
        % 从上交所的期权列表中初始化所有的optinfo，建立一系列optinfo10000283
        [ oi, m2tkCallinfo, m2tkPutinfo ] = init_from_sse_excel( OptInfoXls );
        % demo
        demo;
        % 基于特征获取历史合约代码
        [stockCode, startDate, expireDate] = fetch_optCode_by_feature(CP, strike, ExpireDate);
    end
    
    
end