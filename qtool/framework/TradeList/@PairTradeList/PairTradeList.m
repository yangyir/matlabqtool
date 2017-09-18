classdef PairTradeList<handle
    % PairTradeList �Ǽ�¼��ԵĲ����źŵ�һ����
    % ��Ϊһ�����ݷ������м�����
    
    % ����ԭ�򣬲�ͬ���Բ���ԣ���ͬ��round ����ԣ���ͬ��Ĳ����
    % round��Ϊһ����Ļغϵı�ǩ
    % round�ǿ�������ģ�����ִμӲֵĲ��ԣ��ȿ���ÿ�μӲ���һ����round��
    % �ֿ����Ƕ�μӲ���һ��round��
    % ����ϵͳ���������ʱ��Ҳ���Ը�����Ҫ���±��round��
    
    % ���ڲ��ԣ�round�ɰ����ظ����ã���ҹ���ԣ�round����ÿ���ظ����á�
    % ϵͳ�У���δ��������һ��bug�㡣
    
    % ���䳬��20140703��V1.0
    % ���䳬��20140708��V2.0
    %    1. ���ݼ�¼���������Ǳ��ӯ�������Ǳ�ڿ���������
    %    2. ������TLIdx���Լ�����һЩ���idx
    % ���䳬��20140709��V3.0
    %    1. ������ genSubPTL��findExtremeTrade��plotLossRecover
    %       plotMaxPLossD��plotMaxPProfitD��plotProfitDrawback��
    %       plotTradePnl�ȷ�����
    % ���䳬��20140718��V4.0
    %    1. �����˶�δ��Ե�tick��д��
    % ���䳬��20140725��V5.0
    %    1. ��header�޸�Ϊheaders
    %    2. ��eval���ʽ�򻯡�
    % ���䳬��20140814��V6.0
    %    1. ����sumPair������

    
    properties
        maxRcdNum; % ����¼��
        data; % ��¼��ϸ��Ϣ
        
        rcdNum; % ��¼��Ŀ
        
        instrumentCode;
        fieldNum; % ��¼���ֶ���Ŀ
        headers;
        TLIdx;% TradeList ����ĸ���
        
        % ���ݱ���г����������
        % ���Ҫ֪���������������������getPropIdx�����õ�
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
            % ���캯��
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
            % ɾ��ȫΪ0�Ľ��׼�¼
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
            % ind�������ԣ�ֻ��еִ�С�
            % ind ��ҪΪPTL��¼��һ�µ�logic����
            
            % ���䳬��20140709��V1.0
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
            % threshold Ϊ�жϼ��˽��׵ı�׼�Ĭ��Ϊ2
            
            % ���䳬��20140709��V1.0
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
            % ����ͬһ��round�Ľ���
            rIdx = find(TL.roundNo == roundNo);
            numItem = length(rIdx);
            flagTreated = zeros(numItem,1);
            % ��������ͬһ����Լ�ķ���һ����
            for i = 1:numItem
                if flagTreated(i)==0
                    % ��rIdx���ҵ�ͬһ��instrument��ind
                    iInd = TL.instrumentNo(rIdx)==TL.instrumentNo(rIdx(i));
                    % �ҵ�ͬһ��round��ͬһ��instrument��TL�е�idx
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
            
            % ���䳬��20140708��V2.0
            %    1. �޸����
            % ���䳬��20140730��V2.0
            %    1. �����˶Կ�TradeList�Ĵ���
            
            TL.prune();
            TL.sortByTime();
            obj = PairTradeList(TL);
            if TL.latest == 0
                return;
            end
            strategyType = unique(TL.strategyNo);
            % ���ղ��������
            for i = 1:length(strategyType)
                % �����ԷŽ�һ��TradeList
                SS_TL = TL.slctByStrategy(strategyType(i));
                % �Ե��������
                SS_PTL = obj.pairSS(SS_TL);
                % ����
                obj.add(SS_PTL);
            end
            obj.prune();
            % �˴�ͳһ��δ��ɲ�λ������
            % ��Դ�������ʶ���۸���NaN���档
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

            % ������Ժ������
            obj.sortByTime();
            if nargin == 3
                obj.sum(config);
            else
                obj.sum(config,timeTs,priceTs);
            end
     
        end
        
        
        function [PTL] = pairSS(TL)
            % ͬһ�������ڲ����
            TL.prune();
            PTL = PairTradeList(TL);
            numItem = TL.latest;
            flagTreated  = zeros(numItem,1);
            % ��������ͬһ��round��һ����
            for i = 1:numItem
                if flagTreated(i)==0
                    [rIdx] = PTL.pairRound(TL,TL.roundNo(i));
                    flagTreated(rIdx) = 1;
                end
            end
        end
    end
    
end




