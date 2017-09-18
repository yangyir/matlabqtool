classdef OptionInfo<handle
    %OPTIONINFO 
    % --------------------------
    % 程刚，201511
    % 程刚，20160126，有了一个新的更简洁的类 OptInfo，这个类暂时不怎么用了
    
    
%     合约固定信息
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        contractCode; % 合约编码：10000427
        optCode; % 合约交易代码：'510050C1407M1500'
        optAbbr; % 合约简称：50ETF购11月2100
        optType;  % 'call' , 'put', 'exotic'
        adjustCode; % 调整的编码， 'A', 'B', 'M'
        underCode = '510050.SH'; % 正股代码
        underName = '50ETF'; % 正股名称
        underType = 'etf'; % 正股类型
        underTicks; % 正股Ticks数据（指针）
        underHisVol; % 正股历史volatility
        strikeCode; % 如，3750
        expCode; % 如1407
        strike;  % K，如37.5
%         expDate; % 到期日，如735766
        expDate2; % 到期日，yyyymmdd
        rfr; % 无风险利率，暂时为标量  
        contractMulti = 10000; % 合约单位：10000
    end
    
    %  跟今天日期相关的状态域
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        date; %今天日期
        isTrading = 1; % 是否交易
        isNew = 0; % 是否新挂
        isAdj = 0; % 是否调整
        isHalt = 0; % 是否停牌
        naturalT; % 距离到期日多少自然日
        tradingT; % 距离到期日多少交易日
        preSettle; % 前结算价
        zhangting; % 涨停价
        dieting; % 跌停价
        
    end
    
    methods(Access = 'public', Static = true, Hidden = false)
        function [K, Under, Type, T] = abbrBreakdown(str)
            K = str(end-3:end);
            Under = str(1:5)
            Type = str(6);
            T = str(7:end-4);    
        end
    end
    
        
     methods(Access = 'public', Static = false, Hidden = false)
         % constructor
         function [obj] = OptionInfo()
%              obj = OptionInfo;
             
             
         end
         
         % 读上交所的信息，按上交所默认顺序
%          合约编码	合约交易代码	合约简称	标的券名称及代码	类型	行权价	合约单位	期权行权日	行权交收日	到期日	新挂	涨停价格	跌停价格	前结算价	调整	停牌
         function [obj] = readSSEdailyInfo(obj, str, i)
             % 
                if ~exist('i', 'var'), i = 1 ; end                
             %
             info{i} = regexp(str, '\t', 'split');
             obj.contractCode{i} = info{1}; %合约编码
             obj.optCode{i}    = info{2}; %合约交易代码
             obj.optAbbr{i}    = info{3}; %合约简称
             %标的券名称及代码
             obj.optType{i} = info{5}; %类型	
             obj.strike{i} = info{6}; %行权价	
             obj.contractMulti{i} = info{7}; %合约单位	
             obj.expDate2(i) = str2double(info{8}); %期权行权日	
             %行权交收日	
             %到期日	
             %新挂	
             %涨停价格	
             %跌停价格	
             %前结算价	
             %调整	
             %停牌
         end

             

         function [obj] = autoAbbr(obj)
            str = obj.optAbbr;
            [K,Under, Type, T ] = OptionInfo.abbrBreakdown(str);
            obj.expCode = T;
            obj.strikeCode = K;
            obj.underName = Under;
            obj.optType = Type;  
            obj.strike = str2double(K)*0.01;
            
         end
         
        
         
%          function 
    end
    
end

