classdef QuoteOpt < OptInfo 
% 用于存放行情，尤其是截面行情，期权专用
% ----------------------------------------
% cg，20160108  
% 何康， 20160108
% cg, 20160121, 把期权固态信息专门拿出来，写成OptInfo类，此类继承OptInfo
%     其中，T_t更名为tau
%     fillOptInfo方法放入OptInfo
% 程刚，20160124，增加了复制构造函数
% 程刚，20160211，加入Static函数 [ quote, m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( OptInfoXls );
% 吴云峰，20160217，加入了margin一些相关的函数
% 吴云峰，20160218，基于Wind行情里面获取行情的数据情形
% 程刚，20160302，加如批量计算greeks函数
%         [  ] = calc_ask_all_greeks( obj );
%         [  ] = calc_bid_all_greeks( obj );
%         [  ] = calc_last_all_greeks( obj );
% 朱江，20160327, 从L2行情中构建QuoteOpt;
% cg, 20160331， 添加一些print函数，未完成
% cg, 20160401, 添加[sss] = println_risk_ask(tmp)， [sss] = println_risk_bid(obj)
%       [购9月2150:ask]	1542	1	19.4%	 133.9	 267.8	 3.0	 12.0	 -4.7	 58.5       
% cg, 20160401, 添加 [sss] = print_risk(tmp, pxType)
%       S = 2.1650  |  01-Apr-2016 15:10:06
%       optName	askpx	askQ	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
%       [购9月2150:ask]	1542	1	19.4%	 133.9	 267.8	 3.0	 12.0	 -4.7	 58.5
%       [购9月2150:bid]	1499	2	18.7%	 134.5	 268.9	 3.1	 12.4	 -4.6	 58.4
% 程刚，20160402， 添加  print_pankou(quote)
% 吴云峰，20160403 增加  print_pankou2(quote)
% 何康, 20160414，修改了期权义务仓开仓保证金的计算( 增加一个变量preclose )
% 程刚，20170104，r默认0.035
% 朱江, 20170328, 增加设置r的方法
% 程刚，201705， print_risk 中去掉 2%delta， 2%gamma，因实战发现没用;加tmValue
% 吴云峰 20170524 为了能够读取商品期权合约OptCommodityInfo，修改了init_from_sse_excel的BUG
% cg, 20170803, print_risk中，加入margin

%% 固态的信息
properties
    % 行情源类型：恒生，CTP,飞创
    srcType = '';
    % 行情源ID: 默认为-1
    srcId = -1;
end
properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
%         code;  % 期权代码,形同 10000283,数值型
%         optName; % 形同 '50ETF3月购2200',字符串
%         underCode;% 标的代码,形同 510050,数值型
%         CP = 'call';  % 'C', 'c', 'Call', 'call', 'CALL' OR 'P', 'p', 'put', 'Put', 'PUT'
%         K; % 期权执行价格
%         T; % 期权到期时间,数值型日期，如datenum('2016-1-27')
%         currentDate; % 今天日期,数值型日期，即 today
%         tau;  % 年化剩余时间    
        
        S@double = 0;                  % 标的价格，实时更新
        M;                             % Moneyness;  K/S 或 ln(K/S)
        M_tau;                         % M/sqrt(tau)
        M_shift;                       % (M_tau - (r - pow(sigma, 2)/2)*sqrt(tau))/sigma;
        Z;                             % M_shift/sigma;
        intrinsicValue;                % (S-K)+  或 (K-S)+
        timeValue@double = 0;          % 时间价值 
        timeValue_pct@double = 0;      % timeValue_percent : timeValue / S * 100%
        timeValue_pct_a@double = 0;    % timeValue_pct * 1/tau;
        r@double = 0.035;    % 无风险利率        
        latest; % 最后的一个        
    end
    
    
    %% 行情信息
    properties
       quoteTime;%     行情时间(s)
       min;
       sec;
%        dataStatus;%    DataStatus	
%        secCode;%证券代码	
%        accDeltaFlag;%全量(1)/增量(2)	
       preSettle;   %昨日结算价	
       preClose;
       etfpreClose; %股票ETF的前收盘价
       settle;      %今日结算价	
       open; %开盘价	
       high; %最高价	
       low;  %最低价	
       last; %最新价	
       last_pct; %last_percent: last/S * 100%
       last_pct_a; %last_percent_annualize: last_percent * 1/tau;
       close;%收盘价	
       refP; %动态参考价格	
       virQ; %虚拟匹配数量	
       openInt;%当前合约未平仓数	
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
       pLevel = 5; %行情档位数目
    end
        
    %% 计算值
    properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
         % 这些用last来算
        impvol@double = NaN;
        delta@double = NaN;
        gamma@double = NaN;
        vega@double = NaN;
        theta@double = NaN;
        rho@double = NaN;
        lambda@double = NaN;
        
        % 这些用ask和bid来算
        askimpvol@double = NaN;
        askdelta@double = NaN;
        askgamma@double = NaN;
        askvega@double = NaN;
        asktheta@double = NaN;
        askrho@double = NaN;
        asklambda@double = NaN;
        
        bidimpvol@double = NaN;
        biddelta@double = NaN;
        bidgamma@double = NaN;
        bidvega@double = NaN;
        bidtheta@double = NaN;
        bidrho@double = NaN;
        bidlambda@double = NaN;
    end
    

    
    %% 构造函数，复制构造函数
    methods
        function [px] = get.preClose(obj)
            px = obj.preClose;
            if obj.preClose < 0.00001 && obj.preSettle > 0.00001
                px = obj.preSettle;
            end
        end
        
        function [px] = get.preSettle(obj)
            px = obj.preSettle;
            if obj.preSettle < 0.00001 && obj.preClose > 0.00001
                px = obj.preClose;
            end
        end
        
    end
    methods(Access = 'public', Hidden = true)
        % 构造函数
        function self = QuoteOpt()     
        end     
        [ newobj ] = getCopy( obj );
    end
    
    %% 检验有效性函数
    methods(Access = 'public', Hidden = false)
        function [valid] = is_obj_valid(obj)
            valid = (~strcmp(obj.optName, '无名期权'));
        end
        
        function [valid] = is_quote_valid(obj)
            valid = (~isempty(obj.last) && ~isnan(obj.last) && (obj.last > 0)...
                && (obj.askP1 > 0.00001) && (obj.bidP1 > 0.00001) && (obj.askQ1 > 0) && (obj.bidQ1 > 0));
        end
    end
    %% 
    methods(Access = 'public', Static = false, Hidden = false)
        
        function mg = margin( self , calcMode )
            % 开仓保证金
            % 最低标准
            % 认购期权义务仓开仓保证金＝[合约前结算价+Max（12%×合约标的前收盘价-认购期权虚值，7%×合约标的前收盘价）] ×合约单位
            % 认沽期权义务仓开仓保证金＝Min[合约前结算价+Max（12%×合约标的前收盘价-认沽期权虚值，7%×行权价格），行权价格] ×合约单位
            % 维持保证金
            % 最低标准
            % 认购期权义务仓维持保证金＝[合约结算价+Max（12%×合约标的收盘价-认购期权虚值，7%×合约标的收盘价）]×合约单位
            % 认沽期权义务仓维持保证金＝Min[合约结算价 +Max（12%×合标的收盘价-认沽期权虚值，7%×行权价格），行权价格]×合约单位
            % 其中，认购期权虚值=Max（行权价-合约标的收盘价，0）
            % 认沽期权虚值=max（合约标的收盘价-行权价，0）
            % 吴云峰，增加了一个计算保证金的方式 calcMode( 最初保证金init和维持keep保证金的计算 )
            
            if ~exist( 'calcMode' , 'var' ),calcMode = 'keep';end;
            if isfloat( calcMode ),calcMode = 'keep';end;
            if ~ismember( calcMode , { 'init','keep' } ),calcMode = 'keep';end;
            if isempty( self.etfpreClose ),calcMode = 'keep';end;
            if isnan( self.etfpreClose ),calcMode = 'keep';end;
            
            self.calcIntrinsicValue;
            if isempty( self.preSettle ) 
                preSettle = self.last;
            end 
            if ~isempty( self.preSettle ) 
                if self.preSettle == 0 || isnan( self.preSettle )
                    preSettle = self.last;
                else
                    preSettle = self.preSettle;
                end
            end
            if isempty( self.settle )
                settle = self.last;
            end
            if ~isempty( self.settle ) 
                if self.settle == 0 || isnan( self.settle )
                    settle = self.last;
                else
                    settle = self.preSettle;
                end
            end
            
            % 计算保证金
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL', '认购', '购',1 }
                switch calcMode
                    case 'init'
                        mg = preSettle + max( self.etfpreClose*0.12 - max([self.K - self.S, 0]), self.etfpreClose *0.07 );
                    case 'keep'
                        mg = settle + max( self.S*0.12 - max([self.K - self.S, 0]), self.S *0.07 );
                end
                case {'P', 'p', 'put', 'Put', 'PUT', '认沽',  '沽', 2}
                    switch calcMode
                        case 'init'
                            mg = min( preSettle + max( self.etfpreClose*0.12 - max([self.S - self.K, 0]), self.K*0.07 ), self.K ); 
                        case 'keep'
                            mg = min( settle + max( self.S*0.12 - max([self.S - self.K, 0]), self.K*0.07 ), self.K ); 
                    end
            end
        end
        
        function ratio = calcMarginRate_bid( self )
            % 计算margin的值
            margin = self.margin;
            ratio = self.bidP1/margin;           
        end
        
        % 计算每张期权的交易费用
        function fee = calcFee(self, isAskOpen)
            % 期权手续费分为两部分： 经手费 + 佣金
            % 佣金为每张期权0.3 元
            % 经手费为每张期权2元，卖开 不收经手费
            % 一张期权为10000股。
            if(~exist('isAskOpen', 'var')), isAskOpen = false;end
            
            if(isAskOpen)
                brokerage = 0;%经手费
            else
                brokerage = 2;
            end
            commission = 0.3; %佣金
            fee = brokerage + commission; % 交易费用
        end
        
        % 计算intrinsic value填入
%         function [inValue, tValue] = calcIntrinsicValue( self, S ) 
        function [inValue] = calcIntrinsicValue( self, S )

            % 计算intrinsic value，填入
             if ~exist('S', 'var') 
                S = self.S;
            end                

            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    inValue = max(  [ S - self.K,  0 ]  );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    inValue = max(  [ self.K - S ,  0 ]  );
            end  
%             tValue  = self.askP1 - inValue;
            self.intrinsicValue = inValue;
%             self.timeValue = tValue;
        end
        
        % 计算intrinsic value和timeValue, 填入
        function [inValue, tValue] = calc_intrinsicValue_timeValue( self, S )  
            % 计算intrinsic value，填入
             if ~exist('S', 'var') 
                S = self.S;
            end                

            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    inValue = max(  [ S - self.K,  0 ]  );
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    inValue = max(  [ self.K - S ,  0 ]  );
            end
            tValue  = self.askP1 - inValue;
            self.intrinsicValue = inValue;
            self.timeValue = tValue;
            self.timeValue_pct = tValue / self.S;      % timeValue_percent : timeValue / S * 100%
            self.timeValue_pct_a = self.timeValue_pct / self.tau;    % timeValue_pct * 1/tau;
        end        
        
        function [m] = calcMoneyness(self)
            % 计算moneyness（moneyness的定义待商榷）
            m = log(self.K/self.S);
            m_tau = m / sqrt(self.tau);
            m_shift = (m_tau - (self.r - 0.5 * power(self.impvol, 2))*sqrt(self.tau)) / self.impvol;
            z = m_shift / self.impvol;
            self.M = m;
            self.M_tau = m_tau;
            self.M_shift = m_shift;
            self.Z = z;
        end       
        
        
    end
    
    
    %% 单独写在类外面的函数
    methods(Access = 'public', Static = false, Hidden = false)
        % 设置行情源类型
        [ self ] = setSrcType(self, src_type);
        % 设置行情源ID
        [ self ] = setSrcId(self, src_id); 
        % 设置无风险利率
        [ self ] = setRate(self, rate);
        % 取行情通用函数
        [ self ] = fillQuote(self); 
        % 取H5行情数据， 填入
        [ self ] = fillQuoteH5( self );
        
        % 取Wind行情数据，填入
        [ self ] = fillQuoteWind( self , w );
        
        % 取L2行情数据，填入
        [ self ] = fillQuoteL2(self, l2_str);
        
        % 取CTP行情
        [ self ] = fillQuoteCTP(self);
        
        % 取XSpeed行情
        [ self ] = fillQuoteXSpeed(self);
        
        % 历史行情单独拉出来
        [self] = fillHistoricalQuote(self, day);

    end
    
    methods(Static = true)
        [ quote, m2tkCallQuote, m2tkPutQuote ] = init_from_sse_excel( OptInfoXls );
        [ m2tkCallMargin , m2tkPutMargin ] = calc_margin_rate( OptInfoXls , w );
        demo;
    end
        
      %% 计算数据的函数
    methods(Access = 'public', Static = false, Hidden = false)
        
        %% 批量计算greeks函数
        [  ] = calc_ask_all_greeks( obj );
        [  ] = calc_bid_all_greeks( obj );
        [  ] = calc_last_all_greeks( obj );
        
        %% 计算Dollar Greeks
        function [dollardelta1] = calcDollarDelta1(obj)
            %function [dollardelta1] = calcDollarDelta1(obj)
            dollardelta1 = obj.delta * obj.multiplier * obj.S * 0.01;
        end
        
        %% 计算用的小函数，每个只算一个greeks量 （思考：是否用getter？）
        % 计算Impvol
        function [vol] = calcImpvol(self, rf)            
            if ~exist('rf', 'var'), rf = self.r; end
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.last, 10, 0, [],{'call'});
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.last, 10, 0, [],{'put'});
            end   
            if isnan(vol)
                vol = 0.0001;
            end
            self.impvol = vol;
        end
        
        function [vol] = calcImpvol_bid(self, rf)   
            if ~exist('rf', 'var'), rf = self.r; end
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.bidP1, 10, 0, [],{'call'});
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    vol = blsimpv( self.S, self.K, rf, self.tau, self.bidP1, 10, 0, [],{'put'});
            end   
            self.bidimpvol = vol;
        end
        
        function [vol] = calcImpvol_ask(self, rf)    
            if ~exist('rf', 'var'), rf = self.r; end
            tau = self.tau;
            
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    vol = blsimpv( self.S, self.K, rf, tau, self.askP1, 10, 0, [],{'call'});
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    vol = blsimpv( self.S, self.K, rf, tau, self.askP1, 10, 0, [],{'put'});
            end              
            self.askimpvol = vol;
        end
        
        %%%%%%%%%%%%%%%%%%新增
        % 计算delta 
        % 使用lastprice
        function [self] = calcDelta(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            [cdelta,pdelta] = blsdelta( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.delta = cdelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.delta = pdelta;
            end
            
        end
        
        % 使用bidprice
        function [self] = calcDelta_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end
           
            [cbiddelta,pbiddelta] = blsdelta( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.biddelta = cbiddelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.biddelta = pbiddelta;
            end
            
        end
        
        % 使用askprice
        function [self] = calcDelta_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            [caskdelta,paskdelta] = blsdelta( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.askdelta = caskdelta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.askdelta = paskdelta;
            end
            
        end
        
        % 计算Gamma
        
        function [self] = calcGamma(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.gamma = NaN;
                return;
            end
            
            self.gamma = blsgamma(self.S, self.K, rf, self.tau, impvol);    
        end
        % 计算bidgamma
        function [self] = calcGamma_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            self.bidgamma = blsgamma(self.S, self.K, rf, self.tau, impvol_bid);
        end
        % 计算askgamma
        function [self] = calcGamma_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            self.askgamma = blsgamma(self.S, self.K, rf, self.tau, impvol_ask);
        end
        
        % 计算Vega    
        function [self] = calcVega(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            
            self.vega = blsvega(self.S, self.K, rf, self.tau, impvol);
        end
        % 计算bidvega
        function [self] = calcVega_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            self.bidvega = blsvega(self.S, self.K, rf, self.tau, self.bidimpvol);
        end
        % 计算askvega
        function [self] = calcVega_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
                        if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            self.askvega = blsvega(self.S, self.K, rf, self.tau, impvol_ask);
        end
        
        % 计算theta
        % 使用lastprice
        function [self] = calcTheta(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end

            [ctheta,ptheta] = blstheta( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.theta = ctheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.theta = ptheta;
            end
            
        end
        
        % 使用bidprice
        function [self] = calcTheta_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            [cbidtheta,pbidtheta] = blstheta( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.bidtheta = cbidtheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.bidtheta = pbidtheta;
            end
        end
        
        % 使用askprice
        function [self] = calcTheta_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end

            [casktheta,pasktheta] = blstheta( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.asktheta = casktheta;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.asktheta = pasktheta;
            end
            
        end
        
        % 计算rho
        % 使用lastprice
        function [self] = calcRho(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            
            [crho,prho] = blsrho( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.rho = crho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.rho = prho;
            end
            
        end
        
        % 使用bidprice
        function [self] = calcRho_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end

            [cbidrho,pbidrho] = blsrho( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.bidrho = cbidrho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.bidrho = pbidrho;
            end
            
        end
        
        % 使用askprice
        function [self] = calcRho_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end
            
            [caskrho,paskrho] = blsrho( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.askrho = caskrho;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.askrho = paskrho;
            end
            
        end        
        
        % 计算lambda
        % 使用lastprice
        function [self] = calcLambda(self, rf, impvol)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol', 'var')
                impvol = self.calcImpvol(rf);
            end
            if (isnan(impvol))
                self.delta = NaN;
                return;
            end
            
            [clambda,plambda] = blslambda( self.S, self.K, rf, self.tau, impvol);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.lambda = clambda;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.lambda = plambda;
            end
            
        end
        
        % 使用bidprice
        function [self] = calcLambda_bid(self, rf, impvol_bid)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_bid', 'var')
                impvol_bid = self.calcImpvol_bid(rf);
            end
            if (isnan(impvol_bid))
                self.biddelta = NaN;
                return;
            end
            
            [cbidlambda,pbidlambda] = blslambda( self.S, self.K, rf, self.tau, impvol_bid);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.bidlambda = cbidlambda;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.bidlambda = pbidlambda;
            end
            
        end
        
        % 使用askprice
        function [self] = calcLambda_ask(self, rf, impvol_ask)
            if ~exist('rf', 'var'), rf = self.r; end
            if ~exist('impvol_ask', 'var')
                impvol_ask = self.calcImpvol_ask(rf);
            end
            if (isnan(impvol_ask))
                self.askdelta = NaN;
                return;
            end
            [casklambda,pasklambda] = blslambda( self.S, self.K, rf, self.tau, impvol_ask);
            switch self.CP
                case {'C', 'c', 'Call', 'call', 'CALL' }
                    self.asklambda = casklambda;
                case {'P', 'p', 'put', 'Put', 'PUT'}
                    self.asklambda = pasklambda;
            end
            
        end
   
    end

    %% 一些类型转换的小函数工具    
    methods
        % 从QuoteOpt转换成OptPricer， 提取要素即可，涉及到使用什么sigma的问题
        function [optPricer ]  = QuoteOpt_2_OptPricer(quoteOpt, vol_type)
            %   vol_type取值：'ask', 'bid', 'last'
            optPricer = OptPricer;
            
            flds    = properties(OptInfo);
            flds{end+1}  = 'S';
            flds{end+1}  = 'r';
            L       = length(flds);
            for i = 1:L
                fld = flds{i};
                optPricer.(fld) = quoteOpt.(fld);
            end
            
%             sigma: 0.3000
%             S: []
%             r: 0.0500
%             model: 'BS'
%             intrinsicValue: []
%             timeValue: []
%             px: []
            

            %% 处理sigma的问题
            
            % 如有必要重算iv
            if ~exist('vol_type', 'var'), vol_type = 'last'; end
            switch vol_type
                case {'ask'}
                    optPricer.sigma = quoteOpt.askimpvol;
                case {'bid'}
                    optPricer.sigma = quoteOpt.bidimpvol;
                case{'last'}
                    optPricer.sigma = quoteOpt.impvol;
                otherwise
                    optPricer.sigma = quoteOpt.impvol;
            end

        end
        
        % 从QuoteOpt转换成OptInfo（父类）， 提取中间的要素即可
        function [optInfo] = QuoteOpt_2_OptInfo(quoteOpt)
            optInfo = OptInfo; 
            
            flds    = properties(optInfo);
            L       = length(flds);
            for i = 1:L
                fld = flds{i};
                optInfo.(fld) = quoteOpt.(fld);
            end
            
        end
        
        
    end
    
    
    %% 输出
    methods
% S = 2.315  |  09-May-2017 14:06:42
% optName	askPx	askQ	iv	1%delta	1%gamma	Dtheta	1%vega	timeV
% [购12月2300:ask]	677	10	2.0%	 223.2	 5.5	 -2.1	 14.7	 527
% [购12月2300:bid]	671	10	1.4%	 230.3	 1.5	 -2.2	 2.7	 521
        function [sss] = print_risk(obj, pxType)
            if ~exist('pxType', 'var') 
                pxType = 'both';
            end
            
%             tmp.calc_ask_all_greeks;
            
            S       = obj.S;
            fprintf('S = %0.3f  |  %s  | mg %0.0f\n', S, datestr(now), obj.margin * obj.multiplier);
            fprintf('optName\taskPx\taskQ\tiv\t1%%delta\t1%%gamma\tDtheta\t1%%vega\ttimeV\ttimeV%%\n');

            switch(pxType)
                case{ 'ask' }
                    sss = obj.println_risk_ask;
                    
                case{ 'bid' }                    
                    sss = obj.println_risk_bid;

                case{ 'both' }
                     sss(1,:) = obj.println_risk_ask;
                     sss(2,:) = obj.println_risk_bid;

            end
        end
        
% optName	askpx	askQ	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购9月2150:ask]	1542	1	19.4%	 133.9	 267.8	 3.0	 12.0	 -4.7	 58.5       
        function [risk] = println_risk_ask(obj)
            

            obj.calc_ask_all_greeks;
            
            S       = obj.S;
            on      = obj.optName(6:end);
            px      = obj.askP1 * obj.multiplier;
            q       = obj.askQ1;
            iv      = obj.askimpvol*100;
            delta   = obj.askdelta * obj.multiplier * S*0.01;
%             delta2  = obj.askdelta * obj.multiplier * S*0.02;
            gamma  = obj.askgamma * obj.multiplier * S*S*0.0001/2 ;
%             gamma2  = obj.askgamma * obj.multiplier * S*S*0.0004/2 ;
            theta   = obj.asktheta * obj.multiplier / 365 ;
            vega    = obj.askvega * obj.multiplier * 0.01;
            
            
            obj.calc_intrinsicValue_timeValue;            
            inV     = obj.intrinsicValue * obj.multiplier;
            tmV     = px - inV;
            tmV_pcta= obj.timeValue_pct_a * 100;
            
            risk    = [px, q, iv, delta,  gamma,  theta, vega, tmV, tmV_pcta];
            
            fprintf('[%s:ask]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\t %0.1f%%\n', on,...
                px, q, iv, delta,   gamma, theta, vega, tmV, tmV_pcta);
            
        end
        
        
% optName	askpx	askQ	iv	1% 2%delta	1% 2%gamma	Dtheta	1%vega
% [购9月2150:bid]	1499	2	18.7%	 134.5	 268.9	 3.1	 12.4	 -4.6	 58.4
        function [risk] = println_risk_bid(obj)
            
            obj.calc_ask_all_greeks;
            
            S       = obj.S;
            on      = obj.optName(6:end);
            px      = obj.bidP1 * obj.multiplier;
            q       = obj.bidQ1;
            iv      = obj.bidimpvol*100;
            delta   = obj.biddelta * obj.multiplier * S*0.01;
%             delta2  = obj.biddelta * obj.multiplier * S*0.02;
            gamma  = obj.bidgamma * obj.multiplier * S*S*0.0001/2 ;
%             gamma2  = obj.bidgamma * obj.multiplier * S*S*0.0004/2 ;
            theta   = obj.bidtheta * obj.multiplier / 365 ;
            vega    = obj.bidvega * obj.multiplier * 0.01;
          
            
            obj.calc_intrinsicValue_timeValue;
            inV     = obj.intrinsicValue * obj.multiplier;
            tmV     = px - inV;
            tmV_pcta= obj.timeValue_pct_a * 100;
            
            
            risk    = [px, q, iv, delta,  gamma,  theta, vega, tmV, tmV_pcta];
            
            fprintf('[%s:bid]\t%0.0f\t%d\t%0.1f%%\t %0.1f\t %0.1f\t %0.1f\t %0.1f\t %0.0f\t %0.1f%%\n', on,...
                px, q, iv, delta,   gamma,  theta, vega, tmV, tmV_pcta);
        end
        
        
        function print_pankou(quote)
            % 打印盘口情况
            % 形同：
%             7	0.1745
%             2	0.1736
%             1	0.1735
%            10	0.1730
%             8	0.1729
%             --------------------------
%                 0.1705	1
%                 0.1704	1
%                 0.1699	1
%                 0.1690	1
%                 0.1687	10
            
            mat1(1,:) = [quote.askQ5, quote.askP5];
            mat1(2,:) = [quote.askQ4, quote.askP4];
            mat1(3,:) = [quote.askQ3, quote.askP3];
            mat1(4,:) = [quote.askQ2, quote.askP2];
            mat1(5,:) = [quote.askQ1, quote.askP1];
            
            
            mat2(1,:) = [quote.bidP1, quote.bidQ1];
            mat2(2,:) = [quote.bidP2, quote.bidQ2];            
            mat2(3,:) = [quote.bidP3, quote.bidQ3];
            mat2(4,:) = [quote.bidP4, quote.bidQ4];
            mat2(5,:) = [quote.bidP5, quote.bidQ5];

            for i = 1:5
                fprintf('%d\t%0.4f\n', mat1(i,1), mat1(i,2));
            end
            fprintf('-----------------------\n');
            for i = 1:5
                fprintf('\t%0.4f\t%d\n', mat2(i,1), mat2(i,2));
            end
            
        end
        
        
        function mat = print_pankou2( quote )
            mat1(1,:) = [quote.askQ5, quote.askP5];
            mat1(2,:) = [quote.askQ4, quote.askP4];
            mat1(3,:) = [quote.askQ3, quote.askP3];
            mat1(4,:) = [quote.askQ2, quote.askP2];
            mat1(5,:) = [quote.askQ1, quote.askP1];
            last  = quote.last;
            mat2(1,:) = [quote.bidP1, quote.bidQ1];
            mat2(2,:) = [quote.bidP2, quote.bidQ2];            
            mat2(3,:) = [quote.bidP3, quote.bidQ3];
            mat2(4,:) = [quote.bidP4, quote.bidQ4];
            mat2(5,:) = [quote.bidP5, quote.bidQ5];
            
            % 将所有的数据放置在一个mat里面
            mat = cell( 10 , 3 );
            mat( 1:5  , 1:2 ) = num2cell( mat1 ); 
            mat( 6:10 , 2:3 ) = num2cell( mat2 );
            
        end
        
    end

    %% 为测试便利，提供一个随机生成的对象方法
    methods (Access = 'public', Static = true)
        function [obj] = RandomInstance()
            obj = QuoteOpt;
            for i = 1:5
                c_bidP = ['bidP',num2str(i)];
                c_bidV = ['bidQ',num2str(i)];
                obj.(c_bidP) = randi([1 + 50*i, 50 * (i+1)]);
                obj.(c_bidV) = randi([0, 100]);
                c_askP = ['askP',num2str(i)];
                c_askV = ['askQ',num2str(i)];
                obj.(c_askP) = randi([1 + 50*i + 400, 50 * (i+1) + 400]);
                obj.(c_askV) = randi([0, 100]);                
            end
        end
    end
    
end
