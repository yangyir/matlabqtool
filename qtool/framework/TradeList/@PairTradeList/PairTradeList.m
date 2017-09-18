classdef PairTradeList<handle
    % PairTradeList 是记录配对的策略信号的一个表。
    % 作为一个数据分析的中间载体
    
    % 基本原则，不同策略不配对，不同的round 不配对，不同标的不配对
    % round做为一个大的回合的标签
    % round是可以灵活定义的，比如分次加仓的策略，既可以每次加仓算一个新round，
    % 又可以是多次加仓算一个round。
    % 评估系统在做处理的时候，也可以根据需要重新标记round。
    
    % 日内策略，round可按日重复利用；隔夜策略，round不能每日重复利用。
    % 系统中，暂未处理。这是一个bug点。
    
    % 潘其超，20140703，V1.0
    % 潘其超，20140708，V2.0
    %    1. 数据记录加入了最大潜在盈利，最大潜在亏损两个域
    %    2. 加入了TLIdx域，以及其他一些域的idx
    % 潘其超，20140709，V3.0
    %    1. 加入了 genSubPTL，findExtremeTrade，plotLossRecover
    %       plotMaxPLossD，plotMaxPProfitD，plotProfitDrawback，
    %       plotTradePnl等方法。
    % 潘其超，20140718，V4.0
    %    1. 加入了对未配对的tick填写。
    % 潘其超，20140725，V5.0
    %    1. 将header修改为headers
    %    2. 将eval表达式简化。
    % 潘其超，20140814，V6.0
    %    1. 加入sumPair方法。

    
    properties
        maxRcdNum; % 最大记录数
        data; % 记录详细信息
        
        rcdNum; % 记录数目
        
        instrumentCode;
        fieldNum; % 记录的字段数目
        headers;
        TLIdx;% TradeList 中域的个数
        
        % 数据表格中常用域的索引
        % 如果要知道其他域的索引，可以用getPropIdx方法得到
        volumeI;
        priceI;
        directionI;
        offSetFlagI;
        tradeIDI;
        timeI;
        strategyNoI;
        instrumentNoI;
        roundNoI;
        cmsnI;
        pnlI;
        spanI;
        maxProfitI;
        maxLossI;
        tickI;     
    end
    
    
    methods
        
        
        
        function obj = PairTradeList(TL)
            % 构造函数
            TL.prune();
            obj.headers = [TL.headers,{'commission','pnl','span','maxProfit','maxLoss'}];
            obj.fieldNum  = length(obj.headers);
            obj.maxRcdNum    = TL.latest*2;
            obj.data            = zeros(obj.maxRcdNum,obj.fieldNum);
            obj.rcdNum          = 0;
            obj.TLIdx = length(TL.headers);
            obj.volumeI = obj.getPropIdx('volume');
            obj.priceI = obj.getPropIdx('price');
            obj.directionI = obj.getPropIdx('direction');
            obj.offSetFlagI = obj.getPropIdx('offSetFlag');
            obj.tradeIDI = obj.getPropIdx('tradeID');
            obj.timeI = obj.getPropIdx('time');
            obj.strategyNoI = obj.getPropIdx('strategyNo');
            obj.instrumentNoI = obj.getPropIdx('instrumentNo');
            obj.roundNoI = obj.getPropIdx('roundNo');
            obj.cmsnI = obj.getPropIdx('commission');
            obj.pnlI = obj.getPropIdx('pnl');
            obj.spanI = obj.getPropIdx('span');
            obj.maxProfitI = obj.getPropIdx('maxProfit');
            obj.maxLossI = obj.getPropIdx('maxLoss');
            obj.tickI = obj.getPropIdx('tick');
        end
        
        
        function [] = prune(obj)
            % 删除全为0的交易记录
            obj.data(obj.rcdNum+1:end,:) = [];
            obj.maxRcdNum = obj.rcdNum;
        end
        
        function [] = add(obj,obj2)
            if isempty(obj2.rcdNum)||obj2.rcdNum==0
                return;
            end
            
            if obj.maxRcdNum<obj.rcdNum+obj2.rcdNum
                obj.extend(obj.rcdNum+obj2.rcdNum-obj.maxRcdNum);
            end
            
            obj2.prune();
            
            initNum = obj.rcdNum;
            obj.rcdNum = obj.rcdNum+obj2.rcdNum;
            obj.data(initNum+1:obj.rcdNum,:) = obj2.data;

            
        end
        
        function [] = sortByTime(obj,mode, basis)
            
            if nargin == 1
                mode = 'ascend';
                basis = 'open';
            elseif nargin == 2
                basis = 'open';
            end
            obj.prune();
            
            openData = obj.data(1:2:obj.rcdNum,:);
            closeData = obj.data(2:2:obj.rcdNum,:);
            
            timeIdx = obj.getPropIdx('time');
            if strcmp(basis,'open')
                [~,idx] = sort(openData(:,timeIdx),1,mode);
            else
                [~,idx] = sort(closeData(:,timeIdx),1,mode);
            end
            openData = openData(idx,:);
            closeData = closeData(idx,:);
            
            obj.data(1:2:obj.rcdNum,:) = openData;
            obj.data(2:2:obj.rcdNum,:) = closeData;   
        end
        
        function [] = extend(obj, addNum)
            if nargin == 1
                addNum = 1000;
            end
            
            obj.maxRcdNum = obj.maxRcdNum+addNum;
            obj.data = [obj.data;zeros(addNum,obj.fieldNum)];
  
            
        end
        
        function [idx] = getPropIdx(obj,propName)
            idx = find(strcmp(obj.headers,propName));
            if isempty(idx)
                error('%s is not a property of PairTradeList!',propName);
            end
        end
        
        function [subPTL] = genSubPTL(obj,ind)
            % ind不检查配对，只机械执行。
            % ind 需要为PTL记录数一致的logic向量
            
            % 潘其超，20140709，V1.0
            if ~any(ind)
                subPTL = 0;
                return ;
            end
            save('tmpSubPTL943189.mat','obj');
            subPTL = importdata('tmpSubPTL943189.mat');
            delete('tmpSubPTL943189.mat');
            
            numItem = sum(ind);
            subPTL.data(~ind,:) = [];
            subPTL.maxRcdNum = obj.maxRcdNum + numItem-obj.rcdNum;
            subPTL.rcdNum = numItem;
            
        end
        
        function [extremeTrade] = findExtremeTrade(obj, threshold)
            % threshold 为判断极端交易的标准差，默认为2
            
            % 潘其超，20140709，V1.0
            if nargin ==1
                threshold = 2;
            end
            
            obj.prune();
            pnl = obj.data(1:2:obj.rcdNum,obj.pnlI);
            meanPnl = mean(pnl);
            stdPnl = std(pnl);
            
            extremeIdx = pnl>meanPnl+threshold*stdPnl|pnl<meanPnl-threshold*stdPnl;
            
            ptlIdx = reshape(repmat(extremeIdx',2,1),[],1);
            
            extremeTrade = obj.genSubPTL(ptlIdx);
        end
        
        
        function [rIdx] = pairRound(obj,TL,roundNo)
            % 处理同一个round的交易
            rIdx = find(TL.roundNo == roundNo);
            numItem = length(rIdx);
            flagTreated = zeros(numItem,1);
            % 逐条处理，同一个合约的放在一起处理
            for i = 1:numItem
                if flagTreated(i)==0
                    % 在rIdx中找到同一个instrument的ind
                    iInd = TL.instrumentNo(rIdx)==TL.instrumentNo(rIdx(i));
                    % 找到同一个round，同一个instrument在TL中的idx
                    iIdx = rIdx(iInd);
                    SIInfo = TL.item2vec(iIdx);
                    obj.pairSI(SIInfo)
                    flagTreated(iInd) =1;
                end
            end
        end
        
    end % method
    
    methods
        [] = pairSI(obj,SIInfo);
        [] = sum(obj,config,timeTs,priceTs);
        [rStats] = sumRound(obj);
        [pStats] = sumPair(obj);
        [] = plotProfitDrawback(obj);
        [] = plotLossRecover(obj);
        [] = plotMaxPProfitD(obj);
        [] = plotMaxPLossD(obj);
        [] = plotTradePnl(obj);
    end
    
    %%
    methods(Static = true)
        function obj = PairTL(TL,config,timeTs,priceTs)
            
            % 潘其超，20140708，V2.0
            %    1. 修改入参
            % 潘其超，20140730，V2.0
            %    1. 加入了对空TradeList的处理。
            
            TL.prune();
            TL.sortByTime();
            obj = PairTradeList(TL);
            if TL.latest == 0
                return;
            end
            strategyType = unique(TL.strategyNo);
            % 按照策略来配对
            for i = 1:length(strategyType)
                % 单策略放进一个TradeList
                SS_TL = TL.slctByStrategy(strategyType(i));
                % 对单策略配对
                SS_PTL = obj.pairSS(SS_TL);
                % 加总
                obj.add(SS_PTL);
            end
            obj.prune();
            % 此处统一对未完成仓位做处理
            % 配对处仅做标识，价格用NaN代替。
            timeT = obj.data(:,obj.timeI);
            stlmtPosInd =isnan(timeT(1:obj.rcdNum));
            timeT(stlmtPosInd) = config.settleTime;
            obj.data(:,obj.timeI) = timeT;
            % 20140718
            obj.data(stlmtPosInd,obj.tickI) = length(timeTs);
            stlmPosIdx = find(stlmtPosInd);
            for i = 1:length(stlmPosIdx)
                instrTypeInd = config.instrType == obj.data(stlmPosIdx(i),obj.instrumentNoI);
                obj.data(stlmPosIdx(i),obj.priceI) = config.settlePrice(instrTypeInd);
            end

            % 对配对以后的排序
            obj.sortByTime();
            if nargin == 3
                obj.sum(config);
            else
                obj.sum(config,timeTs,priceTs);
            end
     
        end
        
        
        function [PTL] = pairSS(TL)
            % 同一个策略内部配对
            TL.prune();
            PTL = PairTradeList(TL);
            numItem = TL.latest;
            flagTreated  = zeros(numItem,1);
            % 逐条处理，同一个round的一起处理
            for i = 1:numItem
                if flagTreated(i)==0
                    [rIdx] = PTL.pairRound(TL,TL.roundNo(i));
                    flagTreated(rIdx) = 1;
                end
            end
        end
    end
    
end




