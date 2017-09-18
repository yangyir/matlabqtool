classdef EntrustList<TEBase
    %ENTRUSTLIST ί�м�¼����������
    
    % ���䳬��20140618��V1.0
    % ���䳬��20140725��V2.0
    %   1. ��eval���ʽ�򻯡�
    % ���䳬��20140729��V3.0
    %   1. �����˽���ר�÷���updEntrustItem
    % �̸գ�20140805��V4.0
    %   1. ����headers��toTable��toExcel����
    % ���䳬��20140806��V5.0
    %   1. delete headers, ELVecNames;
    %   2. ɾ��toTable, toExcel ������
    %   3. delete extend, prune ������
    % �̸գ�20140806��V5.1
    %   1����toTable��toExcel�������븸��TEBase��
    
    
    
    
    %% ���¾�ΪN��1����
    properties
        orderType;      % ί������, market, limit, stop, fok etc.
        orderStatus;    % ί��״̬
        tradeVolume;    % �ɽ���Ŀ
        cancelVolume;   % ��������
        tradeNum;   % �ɽ�����
        recvTime;   % ��̨ϵͳ����ʱ��
        cancelTime; % ����ʱ��
        updateTime; % ����޸�ʱ��
        currTick;   % �źŶ�Ӧ�ĵ�ǰtick��Ϣ
        nextTick;   % �źŶ�Ӧ����һ��tick��Ϣ
        currBar;    % �źŶ�Ӧ�ĵ�ǰbar��Ϣ
        nextBar;    % �źŶ�Ӧ����һ��bar��Ϣ
    end
    
    
    %%
    methods
        function obj = EntrustList(capacity)
            if nargin == 0
                capacity = 1000;
            end
                        
            newVecNames = {'orderType','orderStatus','tradeVolume','cancelVolume',...
                'tradeNum','recvTime','cancelTime','updateTime'};
            obj.headers = [obj.headers, newVecNames];
         

            for i = 1:length(obj.headers)
                obj.(obj.headers{i})= zeros(capacity,1);
            end
        end
        
    end
    
    %% ����ר��
    methods
        function [] = updEntrustItem(obj,newEntrust,instrumentCode)
            
            % ���䳬��20140725��V1.0
            % ���䳬��20140804��V2.0
            %    1. �����˶�roundNo��combNo�ĸ��¡�
            
            
            flagNew = false;
            % �����жϸ�Entrust�Ƿ��Ѿ�����
            if obj.latest ~= 0
                ind = obj.entrustNo(1:obj.latest)==newEntrust.entrustNo;
                if ~any(ind)
                    % �µ�
                    flagNew = true;
                end
            else
                flagNew = true;
            end
            
            if flagNew
                obj.latest  = obj.latest+1;
                idx         = obj.latest;
                obj.time(idx)       = newEntrust.entrustTime;
                obj.entrustNo(idx)  = newEntrust.entrustNo;
                obj.strategyNo(idx) = newEntrust.strategyNo;
                obj.direction(idx)  = newEntrust.direction;
                obj.offSetFlag(idx) = newEntrust.offSetFlag;
                obj.price(idx)      = newEntrust.entrustPrice;
                obj.volume(idx)     = newEntrust.entrustVolume;
                obj.instrumentNo(idx) = instrumentCode(newEntrust.instrumentID);
                obj.orderRef(idx)   = newEntrust.orderRef;
                obj.roundNo(idx)    = newEntrust.roundNo;
                obj.combNo(idx)     = newEntrust.combNo;
            else
                idx = find(ind);
            end
            
            obj.orderStatus(idx)    = str2double(newEntrust.orderStatus);
            obj.tradeVolume(idx)    = newEntrust.tradeVolume;
            obj.cancelVolume(idx)   = newEntrust.cancelVolume;
            obj.updateTime(idx)     = now;
            obj.tradeNum(idx)       = newEntrust.tradeNum;
        end
        
    end
    
end

