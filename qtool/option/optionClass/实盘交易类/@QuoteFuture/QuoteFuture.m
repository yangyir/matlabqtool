classdef QuoteFuture < FutureInfo  %< handle
% 用于存放行情，尤其是截面行情，期货专用
% ----------------------------------------
% 朱江 20160314 仿QuoteOpt
    %% 固态的信息
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
        futureInfo@FutureInfo;    % 期权信息        
        latest; % 最后的一个
    end
    properties
        % 行情源类型：恒生，CTP,飞创
        srcType = '';
        % 行情源ID, 默认值设为-1
        srcId = -1;
        % Greeks 
        delta = 1;
        gamma = 0;
        vega = 0;
        theta = 0;        
        pLevel = 1;
    end
    
    %% 行情信息
    properties
       quoteTime;%     行情时间(s)
%        dataStatus;%    DataStatus	
%        secCode;%证券代码	
%        accDeltaFlag;%全量(1)/增量(2)	
       preClose;
       preSettle;%昨日结算价	
%        settle;%今日结算价	
       open; %开盘价	
       high; %最高价	
       low;  %最低价	
       last; %最新价	
       close;%收盘价	
       refP; %动态参考价格	
       virQ; %虚拟匹配数量	
       openInt;%当前合约未平仓数	
       bidQ1;%申买量1	
       bidP1;%申买价1	
%        bidQ2;%申买量2	
%        bidP2;%申买价2
%        bidQ3;%申买量3	
%        bidP3;%申买价3	
%        bidQ4;%申买量4	
%        bidP4;%申买价4	
%        bidQ5;%申买量5	
%        bidP5;%申买价5	
       askQ1;%申卖量1	
       askP1;%申卖价1	
%        askQ2;%申卖量2	
%        askP2;%申卖价2	
%        askQ3;%申卖量3	
%        askP3;%申卖价3	
%        askQ4;%申卖量4	
%        askP4;%申卖价4	
%        askQ5;%申卖量5	
%        askP5;%申卖价5	
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
        function self = QuoteFuture()
                   
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
    
    methods
        %% 计算Dollar Greeks
        function [dollardelta1] = calcDollarDelta1(obj)
            %function [dollardelta1] = calcDollarDelta1(obj)
            dollardelta1 = obj.delta * obj.multiplier * obj.last * 0.01;
        end                
    end
    
    %% 检验有效性函数
    methods(Access = 'public', Hidden = false)
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '无名期货'));
        end
        
        function [valid] = is_quote_valid(obj)
            valid = (~isempty(obj.last) && ~isnan(obj.last) && (obj.last > 0)...
                    && (obj.askP1 > 0) && (obj.bidP1 > 0) && (obj.askQ1 > 0) && (obj.bidQ1 > 0));
        end
    end
    %% 
    methods(Access = 'public', Static = false, Hidden = false)
        
        function mg = margin( self, account_type )
            
            %开仓保证金
            % 期货保证金比例：投机为40%， 套保为40%
            
            if ~exist('account_type', 'var')
                account_type = '套保';
            end
            
            if isempty( self.preSettle ) 
                preSettle = self.last;
            else 
                preSettle = self.preSettle;
            end
            
            if ~isempty( self.preSettle ) 
                if self.preSettle == 0 || isnan( self.preSettle )
                    preSettle = self.last;
                else
                    preSettle = self.preSettle;
                end
            end

            mg = 0;
            ct = Calendar_Test.GetInstance();
            t = ct.trading_fraction_day(now);
            if(t < 1)
                % 日内
                price = self.last;
            else
                % 日末
                price = preSettle;
            end
            
            switch account_type
                case {'投机'}
                    % 投机账户保证金比例为40%
                    mg = price * 0.4;
                case {'套保'}
                    mg = price * 0.2;                    
            end
        end
        
        %计算股指期货交易费用
        function fee = calcFee(self, isCloseToday)
            % 股指期货交易费用 = 面额 * 费率；
            % 普通费率为 0.279 / 10000, 万分之0.279
            % 平今费率为普通费率的100倍，百分之0.279.
            if ~exist('isCloseToday', 'var'), isCloseToday = false;end
            
            if (isCloseToday)
                fee_rate = 0.279 / 100;
            else
                fee_rate = 0.279 / 10000;
            end
            fee = self.last * fee_rate;
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
        
        % 取CTP行情
        [ self ] = fillQuoteCTP( self );
        
        % 取XSpeed行情
        [ self ] = fillQuoteXSpeed(self);

        % 历史行情单独拉出来
        [self] = fillHistoricalQuote(self, day);

    end
    
    
    methods (Access = 'public', Static = true, Hidden = false)
        %% 为测试目的构造一个随机填充的QuoteFuture
        function [obj] = GetRandomInstance()
            obj = QuoteFuture;
            obj.bidP1 = randi([10,50]);
            obj.bidQ1 = randi([1, 100]);
            obj.askP1 = randi([51, 100]);
            obj.askQ1 = randi([1, 100]);
        end
        
        %% 从Excel文件中构造quotes的结构，用Quote_map索引。
        [quotes, quote_map] = init_from_excel(future_infoxls);
    end
    
end
