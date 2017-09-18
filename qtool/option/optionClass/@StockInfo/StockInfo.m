classdef( Hidden = false,Sealed = false ) StockInfo < handle
    %StockInfo放股票的固定信息，通常只放一个，也可放多个
    %calcTau需要变量T和currentDate计算
    % ---------------------------------------------------------------------
    % 朱江， 20160304, first issue
    % 朱江， 20161226, 加入getName 方法，与其余QuoteInfo类型一致
    
    properties(Access = public,Hidden = false)  
        % 常数信息
        code        = '000000';  % (@char,setter控制) 期货代码,形同 '10000283'
        stockName@char = '无名股票';  % 形同 '万科A',字符串
        market = 'sh';
        multiplier = 100;     % 合约乘数
    end
    
    %% 构造函数，拷贝构造函数，隐藏？
    methods(Hidden = true)
        % 复制构造函数
        [ newobj ] = getCopy(obj);      
        
    end
    
    methods
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
        
        function [self] = set.market(self, value)
            if(isa(value, 'char'))
                switch value
                    case {'SH','sH','Sh','sh','shanghai','Shanghai','1'}
                        self.market = 'sh';
                    case {'SZ', 'Sz', 'sZ', 'sz', 'shenzhen', 'Shenzhen', '2'}
                        self.market = 'sz'
                end
            end
        end
        
        function [name] = getName(obj)
            name = obj.stockName;
        end
    end
    
    %% 其他函数
    
    methods(Access = 'public', Static = false, Hidden = false)
        
        function fillStockInfo( self, code, stockName, market)            
            % 填入信息
            self.code = code;
            self.stockName = stockName;
            self.market = market;
        end
        
      
        %输出信息(长字符串)
        function [s] = infoLongstr(obj)
            
            % 形同： 10000239,50ETF3月购2200,call(510050),T=2016-03-12, K=2.3
            s = sprintf('%s,%s,T=%s', obj.code, obj.stockName,...
                datestr(obj.T));            
        end
     
    end
    
%% ---------------------static 方法----------------------

    methods(Access = 'public', Static = true, Hidden = false)
    end
    
end


