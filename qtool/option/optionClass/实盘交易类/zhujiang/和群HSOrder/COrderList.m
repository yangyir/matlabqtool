classdef COrderList < handle
    properties
        currentID;  % ��ǰ�������
        combiNo;    % ��ϱ�ţ���������
        priceType; %�۸����ͣ�Ĭ�ϣ�[]��1��Ϊ�޼۵�,2=�м۵�
        entrustPrice; %ί�м۸񣬱�������
        entrustAmount; % ί����������������
        marketNo;   %�г����룬�������� (1=�Ͻ�����2=�����7=�н���)
        stockCode;  %��Ʊ���룬��������
        entrustDirection; %ί�з��򣬱������� 1=��2=��
        extsystemId;    %��ʶID���������ݣ�ͬһ��ϲ����ظ� ��1,2,3,...��
        futuresDirection; %��ƽ���򣬹�Ʊ���Բ��� (1=���֣�2=ƽ��)
        coveredFlag;    %���ұ�ʶ��ֻ����Ȩ����ʹ�ã�Ĭ�ϷǱ��� ��[],1=�Ǳ��ң�2=���ң�
        stockholderID;%�ɶ����룬��Ȩ��Ҫ��O32ϵͳ���ò�����
        limitEntrustRatio; %��Сί�б���,ֻȡ��һ�е���ֵ��Ĭ����0��ȫ������ί��
        maxOrderNum;    %����µ������µ�������������
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
        
        % ���õ�ǰ�Ķ������
        function [flag] = setCurrentID(obj, k)
            if obj.maxOrderNum < k
                flag = 0;
            else
                obj.currentID = k;
                flag = 1;
            end
        end
        
        % ���ø�������ִ�е���Сί�б���
        function [] = setlimitEntrustRatio(obj, rate)
            obj.limitEntrustRatio = rate;
        end
        
        % ���ö�����������һ��Ĭ��Ϊ��ʼ���е�����
        function [] = setOrderNum(obj, orderNum)
            obj.maxOrderNum = orderNum;
        end
        
        % ����һ���µĶ���
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