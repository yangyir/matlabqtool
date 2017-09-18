classdef COrderList < handle
    properties
        currentID;  % 当前订单序号
        combiNo;    % 组合编号，必填数据
        priceType; %价格类型，默认（[]，1）为限价单,2=市价单
        entrustPrice; %委托价格，必填数据
        entrustAmount; % 委托数量，必填数据
        marketNo;   %市场代码，必填数据 (1=上交所；2=深交所；7=中金所)
        stockCode;  %股票代码，必填数据
        entrustDirection; %委托方向，必填数据 1=买；2=卖
        extsystemId;    %标识ID，必填数据，同一组合不可重复 （1,2,3,...）
        futuresDirection; %开平方向，股票可以不填 (1=开仓；2=平仓)
        coveredFlag;    %备兑标识，只有期权可以使用，默认非备兑 （[],1=非备兑；2=备兑）
        stockholderID;%股东代码，期权需要，O32系统设置不完整
        limitEntrustRatio; %最小委托比例,只取第一行的数值，默认是0，全部进行委托
        maxOrderNum;    %最大下单量，下单的数量，必填
    end
    
    methods
        function obj = COrderList(orderNum)
            obj.currentID           = 0;
            obj.combiNo             = cell(orderNum,1);
            obj.stockholderID       = cell(orderNum,1);
            obj.marketNo            = zeros(orderNum,1);
            obj.stockCode           = cell(orderNum,1);
            obj.entrustDirection    = zeros(orderNum,1);
            obj.futuresDirection    = -1*ones(orderNum,1);
            obj.coveredFlag         = zeros(orderNum,1);
            obj.priceType           = zeros(orderNum,1);
            obj.entrustPrice        = zeros(orderNum,1);
            obj.entrustAmount       = zeros(orderNum,1);
            obj.limitEntrustRatio   = 0;
            obj.extsystemId         = zeros(orderNum,1);
            obj.maxOrderNum         = orderNum;
        end
        
        % 设置当前的订单序号
        function [flag] = setCurrentID(obj, k)
            if obj.maxOrderNum < k
                flag = 0;
            else
                obj.currentID = k;
                flag = 1;
            end
        end
        
        % 设置该批订单执行的最小委托比例
        function [] = setlimitEntrustRatio(obj, rate)
            obj.limitEntrustRatio = rate;
        end
        
        % 设置订单的数量，一般默认为初始化中的数量
        function [] = setOrderNum(obj, orderNum)
            obj.maxOrderNum = orderNum;
        end
        
        % 加入一个新的订单
        function [] = fillOrder(obj, combiNo, marketNo, stockCode, entrustDirection,...
                entrustPrice, entrustAmount, extsystemId, futuresDirection , priceType,...
                coveredFlag, stockholderID)
            obj.combiNo{obj.currentID} = combiNo;
            obj.marketNo(obj.currentID) = marketNo;
            obj.stockCode{obj.currentID} = stockCode;
            obj.entrustDirection(obj.currentID) = entrustDirection;
            obj.entrustPrice(obj.currentID) = entrustPrice;
            obj.entrustAmount(obj.currentID) = entrustAmount;
            obj.extsystemId(obj.currentID) = extsystemId;
            if ~isempty(futuresDirection)
                obj.futuresDirection(obj.currentID) = futuresDirection;
            end
            if ~isempty(priceType)
                obj.priceType(obj.currentID) = priceType;
            end
            if ~isempty(coveredFlag)
                obj.coveredFlag(obj.currentID) = coveredFlag;
            end
            if ~isempty(stockholderID)
                obj.stockholderID{obj.currentID} = stockholderID;
            end
        end
    end
end