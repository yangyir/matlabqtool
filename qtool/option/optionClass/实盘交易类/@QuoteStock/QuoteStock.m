classdef QuoteStock < StockInfo  %< handle
% 用于存放行情，尤其是截面行情，股票专用
% ----------------------------------------
% 朱江 20160314 仿QuoteOpt
    %% 固态的信息
    properties
        % 行情源类型：恒生，CTP,飞创
        srcType = '';
        % 行情源ID，默认值设为-1
        srcId = -1;
        % Greeks 
        delta = 1;
        gamma = 0;
        vega = 0;
        theta = 0;
        pLevel = 5;
    end
    
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        stockInfo@StockInfo;    % 期权信息        
        latest; % 最后的一个
    end
    
    
    %% 行情信息
    properties
       quoteTime;%     行情时间(s)
%        dataStatus;%    DataStatus	
%        secCode;%证券代码	
%        accDeltaFlag;%全量(1)/增量(2)	
%        preSettle;%昨日结算价	
%        settle;%今日结算价	
       preClose;
       preSettle;
       open; %开盘价	
       high; %最高价	
       low;  %最低价	
       last; %最新价	
       close;%收盘价	
%        refP; %动态参考价格	
%        virQ; %虚拟匹配数量	
       bidQ1;%申买量1	
       bidP1;%申买价1	
       bidQ2;%申买量2	
       bidP2;%申买价2
       bidQ3;%申买量3	
       bidP3;%申买价3	
       bidQ4;%申买量4	
       bidP4;%申买价4	
       bidQ5;%申买量5	
       bidP5;%申买价5	
       askQ1;%申卖量1	
       askP1;%申卖价1	
       askQ2;%申卖量2	
       askP2;%申卖价2	
       askQ3;%申卖量3	
       askP3;%申卖价3	
       askQ4;%申卖量4	
       askP4;%申卖价4	
       askQ5;%申卖量5	
       askP5;%申卖价5	
       volume = 0; %累计成交数量	
       amount;     %累计成交金额	
%        rtflag;%产品实时阶段标志	
%        mktTime;%市场时间(0.01s)
       diffVolume; %累计成交数量的增量
       diffAmount; %累计成交金额的增量    
    end
    
    %% 构造函数，复制构造函数
    methods(Access = 'public', Hidden = true)
        % 构造函数
        function self = QuoteStock()
                   
        end     
    
        function [ newobj ] = getCopy( obj )
            % getCopy() is for deep copy case.
            newobj = feval(class(obj));
            % copy all non-hidden properties
            p = properties(obj);
            for i = 1:length(p)
                newobj.(p{i}) = obj.(p{i});
            end
        end
        
    end
    
    %% 检验有效性函数
    methods(Access = 'public', Hidden = false)
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '无名股票'));
        end
        
        function [valid] = is_quote_valid(obj)
            valid = (~isempty(obj.last) && ~isnan(obj.last) && (obj.last > 0));
        end
    end
    
    methods
        %% 计算Dollar Greeks
        function [dollardelta1] = calcDollarDelta1(obj)
            %function [dollardelta1] = calcDollarDelta1(obj)
            dollardelta1 = obj.delta * obj.multiplier * obj.last * 0.01;
        end        
    end
    
    %% 单独写在类外面的函数
    methods(Access = 'public', Static = false, Hidden = false)
        % 设置行情源类型
        [ self ] = setSrcType(self, src_type);
        % 设置行情源ID
        [ self ] = setSrcId(self, src_id);
        % 取行情通用函数
        [ self ] = fillQuote(self); 
        
        % 取H5行情数据， 填入
        [ self ] = fillQuoteH5( self );
        
        % 取Wind行情数据，填入
        [ self ] = fillQuoteWind( self , w );
        
        % 取一行L2数据，填入
        [ self ] = fillQuoteL2(self, l2_str);

        % 取CTP行情
        [ self ] = fillQuoteCTP( self );

        % 取XSpeed行情
        [ self ] = fillQuoteXSpeed( self );
        
        % 历史行情单独拉出来
        [self] = fillHistoricalQuote(self, day);
        
    end
    
    methods(Access = 'public', Static = true)
        %% 从Excel文件中构造quotes的结构，用Quote_map索引。
        [quotes, quote_map] = init_from_excel(stockInfoXlsx);
    end
    


    
end
