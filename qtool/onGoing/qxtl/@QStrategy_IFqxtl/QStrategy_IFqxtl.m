classdef QStrategy_IFqxtl < QStrategy
    %IFQXTL 期限套利类，用IF和股票，算套利空间
    % 程刚
    
    properties
        
        % 指向行情数据的指针
        IFticks;
        stockTicks; % 300*1 Ticks指针
        indexTicks;
        
        % 合成index
        stockWeight;  % 300*1
        stockTradable;  % 300*1,  0或1
        stockQ;         % 股票数量，对应一手IF
        pseudoIndexTicks;  % Ticks类
        
        
        % 期限差Ticks
        spreadTicks;
        
        
        % 截面matrix
        stockProfile;  % 最新截面数据， 300*M
        stockCodes;    % 300*1 cells
        profileHeaders;   % last, volume, askP1,askV1, bidP1,bidV1 ...
        preLatest;
        
        % 
        date;
        date2;
        
        % 
        log
        
        
    end
    
    % 交易下单用的properties
    properties
        roundNo;
        combNo;
    end

    
    %% constructor
    methods
        function [obj] = QStrategy_IFqxtl(StrategyNo,StrategyName,InstrumentNum,InstrumentName, ...
                date, IFticks, stockTicks, indexTicks, stockCodes, stockWeight   )
           
            obj      = obj@QStrategy(StrategyNo,StrategyName,InstrumentNum,InstrumentName);
           
            
            obj.date    = datenum(date);
            obj.date2   = datestr(date, 'yyyy-mm-dd');       

            
            % 规定IF指针
            obj.IFticks = IFticks;
            
            % 读取IF信息
            
            
            % 读取沪深300股票指针
            obj.stockTicks = stockTicks; 
            
            
            % 读取沪深300股票信息
            obj.indexTicks = indexTicks;
            
            % 生成pseudoIndex，空
            obj.pseudoIndexTicks = Ticks;
            
            % 生成spreadTicks, 空
            obj.spreadTicks         = SpreadTicks(32400, obj.IFticks, obj.pseudoIndexTicks) ;
%             obj.spreadTicks.ticksA  = obj.IFticks;
%             obj.spreadTicks.ticksB  = obj.pseudoIndexTicks;
            
            %
            obj.stockWeight    = stockWeight;
            obj.stockCodes     = stockCodes;
            
            % 其它变量
            N = length(stockTicks);            
            obj.preLatest = zeros(size(stockTicks));
            obj.profileHeaders = {'last', 'a1','av1','b1','bv1','a2','av2','b2','bv2'};
            M = length(obj.profileHeaders);
            obj.stockProfile = zeros(N, M);
            
            % 日初数量，每份 CSI300 （点数*1元）对应股票股数，未四舍五入
            % 即2400点（元）对应的股票数
            % 如买5手IF，对应5*300* obj.stockQ
            for i = 1:N
                tmp_preClose(i) = obj.stockTicks(i).preSettlement;
            end
            obj.stockQ = obj.stockWeight ./ tmp_preClose' * obj.indexTicks.preSettlement;
            
            
            
            % 其它
            obj.roundNo = 1;
            obj.combNo = 1;
            
            %
            tmppath = 'V:\root\qtool\onGoing\qxtl\log';
            obj.log = fopen( [ tmppath '\log.txt' ] , 'w');
        end
    end
    
    
   
    %% 策略方法    
    methods
        function  runStrategy(obj)
            %% 更新profile和spread
            obj.calcProfile;
            tm = obj.IFticks.time(obj.IFticks.latest);
            obj.calcPseudoIndex(tm);
            
            obj.spreadTicks.update;
            
            
            
            %% 查看价差，下单
            stks = obj.spreadTicks;
            iftks = obj.IFticks;
            pstks = obj.pseudoIndexTicks;
            
            fprintf(obj.log, '%s: %7.1f - %7.2f = %6.4f\n', datestr(tm), iftks.last(iftks.latest), pstks.last(pstks.latest), stks.last(stks.latest));
                        
            % 根据价差情况下单
            enter_threshold = 0.05 * obj.IFticks.last(obj.IFticks.latest) * 4/52; 
            cond1 = stks.bidP(stks.latest,1) > enter_threshold ;
            cond2 = stks.askP(stks.latest,1) < 0;
            
            % 既有仓位， 暂时放为1
            cond3 = 1 ;
            cond4 = 1;
            
            cond_open = cond1 & cond3;
            cond_close = cond2 & cond4;
            
            % 做空spread
            if cond_open
                fprintf('开空仓:');
                obj.stockOrder(1,5);
                obj.ifOrder(-1,5);
                
                % 记录position和进入点位，作为出来的参考       
                
                
                % 走过了一个组合单，要++
                obj.combNo  = obj.combNo  + 1;
            end
            
            
            
            if cond_close
                fprintf('平空仓');
                obj.stockOrder(-1,5);
                obj.ifOrder(1,5);
                
                
                % 走过了一个组合单，要++；且一个回合完成，要++
                obj.roundNo = obj.roundNo + 1;
                obj.combNo  = obj.combNo  + 1;
            end

            
            
            
        end
        
        function [obj] = stockOrder(obj, direction, IFquantity)
            % 先计算volume            
            q = IFquantity * 300 * obj.stockQ;
            q = round(q/100)*100;
            
            
            N = length(obj.stockTicks);

            for i = 1 : N
                
                ticks = obj.stockTicks(i);
                l   = ticks.latest;
                
                
                o = Signal;
                %
                if direction == 1 % 买，用ask1 
                    p = ticks.askP(l,1);
                elseif direction == -1 % 卖，用bid1
                    p = ticks.bidP(l,1);
                end
                % 对价单
                o.price     = p;
                o.volume    = q(i);  % 股
                o.direction = direction;
                o.instrumentID = ticks.code;  % 存疑
                % 如果是撤单，需要说明,默认为0
%                 o.cancelFlag;
                % 欲撤单的委托号
%                 o.cancelEntrustNo;
                % 开平标识
%                 o.offSetFlag;
                o.roundNo   = obj.roundNo;
                o.combNo    = obj.combNo; 
                
                
                % 未必是i
                obj.order(i) = o;
            end
            
            % 或者放到函数外
%             obj.roundNo = obj.roundNo + 1;
%             obj.combNo  = obj.combNo  + 1;
        end
        
        
        function [obj] = ifOrder(obj, direction, IFquantity)

            q = IFquantity;
            
            N = length(obj.stockTicks);
            i = N + 1;
            
            
            
            ticks = obj.IFticks;
            l   = ticks.latest;
            
            
            o = Signal;
            %
            if direction == 1 % 买，用ask1
                p = ticks.askP(l,1);
            elseif direction == -1 % 卖，用bid1
                p = ticks.bidP(l,1);
            end
            % 对价单
            o.price     = p;
            o.volume    = q;  % IF 手
            o.direction = direction;
            o.instrumentID = ticks.code;  % 存疑
            % 如果是撤单，需要说明,默认为0
            %                 o.cancelFlag;
            % 欲撤单的委托号
            %                 o.cancelEntrustNo;
            % 开平标识
            %                 o.offSetFlag;
            o.roundNo   = obj.roundNo;
            o.combNo    = obj.combNo;
            
            
            % 未必是i
            obj.order(i) = o;
            
        end
        
    end
    
    
    
    %% 计算函数 
    methods
        % 重算pseudoIndex
       [obj] = calcPseudoIndex(obj, tm);               
        
        % 只算最新的last，ask，bid
       [obj] = calcProfile(obj);
                    
        
        
        
        %% 算期现差Ticks
        function [obj] = calcSpreadTick(obj, tm)
            stks = obj.spreadTicks;
            
        end
        
        
    end
    
end

