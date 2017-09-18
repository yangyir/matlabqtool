classdef TsRslt<handle;
    %TSRES presents the trade report as time series.
    
    % ���䳬��20140701��V1.0
    
    % ���䳬��20140710��V2.0
    %    1. �������Ƶ�����Լ��Զ����㡣
    %    2. �����ʼ��ֵ�����û�и�����ʼ��ֵ����������ʽ�ռ�õ�2������
    %    3. ������RNR��,calcRNR �������Լ�����sharpe��calmar��drawdown��˽�к�����
    %    4. ������plotNavVec ������
    
    properties
        % ʱ����
        time;
        % ��Լ����
        instrType;
        % ��������
        cmsnRate;
        % ��֤�����
        marginRate;
        % ��Լ����
        multiplier;
        % ����Ƶ��
        timeFrequency;
        % ��ʼ��ֵ
        initNav;
        % return and risk
        RNR;
        
        % ������Arr��β�Ķ���time��instr �ľ�����ʽ
        % �ۼ�pnl����
        cumPnlArr;
        % ��λ����
        posArr;
        % �ۼ�Ӷ�����
        cumCmsnArr;
        % ��ֵ��λ
        maxPosArr;
        % �����ʽ����
        frozenMarginArr;
        
        % ������Vec��β���ǲ����ֱ��������ʽ
        cumPnlVec;
        cumCmsnVec;
        frozenMarginVec;
        
    end
    
    methods
        function obj = TsRslt(timeTs,TL,config,timeFreq)
            obj.time = timeTs;
            % ����������
            obj.instrType =  unique(TL.instrumentNo)';
            
            obj.cmsnRate  = config.cmsnRate;
            obj.marginRate = config.marginRate;
            obj.multiplier = config.multiplier;
            
            if nargin == 4
                obj.timeFrequency = timeFreq;
            else
                [tmpFreq,count] = mode(diff(timeTs));
                if count/length(timeTs)<0.5
                    obj.timeFrequency = 'irregular';
                else
                    if tmpFreq>=1
                        % �ռ���
                        obj.timeFrequency = sprintf('%dday',tmpFreq);
                    elseif tmpFreq>=0.98/1440
                        % ���Ӽ���
                        obj.timeFrequency = sprintf('%dmin',round(tmpFreq*1440));
                    elseif tmpFreq>=0.98/86400
                        % �뼶
                        obj.timeFrequency = sprintf('%dsnd',round(tmpFreq*86400));
                    else
                        % ���뼶
                        obj.timeFrequency = sprintf('%dms',round(tmpFreq*86400000));
                    end
                end
  
            end
            
            
            numTime = length(timeTs);
            numInstr = length(obj.instrType);
            obj.initNav = config.initNav;
            
            obj.cumPnlArr = zeros(numTime,numInstr);
            obj.posArr = zeros(numTime,numInstr);
            obj.cumCmsnArr = zeros(numTime,numInstr);
            obj.maxPosArr = zeros(numTime,numInstr);
            obj.frozenMarginArr = zeros(numTime,numInstr);
            
            obj.cumPnlVec = zeros(numTime,1);
            obj.cumCmsnVec = zeros(numTime,1);
            obj.frozenMarginVec = zeros(numTime,1);
           
        end
        
        function [ ] = calcRNR(obj)
            % Ҫ��������һ�������
            % ��һ�������Ҫ�����ġ�
            nav = obj.initNav+obj.cumPnlVec;
            slicePerDay = find(obj.time<floor(obj.time(1))+1,1,'last');
            
            [obj.RNR.sharpe,obj.RNR.annYield] = SharpeRatio(nav,0,slicePerDay);
            [obj.RNR.maxDD,obj.RNR.MDDsIdx,obj.RNR.MDDeIdx,...
                obj.RNR.longDDD, obj.RNR.longDDeIdx] = calcMaxDD(nav);
            obj.RNR.calmar = obj.RNR.annYield/obj.RNR.maxDD;
            obj.RNR.MDDsTime = datestr(obj.time(obj.RNR.MDDsIdx),'yyyy/mm/dd HH:MM:SS');
            obj.RNR.MDDeTime = datestr(obj.time(obj.RNR.MDDeIdx),'yyyy/mm/dd HH:MM:SS');
            obj.RNR.longDDeTime = datestr(obj.time(obj.RNR.longDDeIdx),'yyyy/mm/dd HH:MM:SS');
            obj.RNR.longDDsTime = datestr(obj.time(obj.RNR.longDDeIdx-obj.RNR.longDDD+1),'yyyy/mm/dd HH:MM:SS');
        end
    end
    
    methods
        [ ] = calcPosTs( obj, TL );
        [ ] = calcPnlTs( obj, TL, price );
        [ ] = plotPnlVec(obj);
        [ ] = plotPos(obj);
        [ ] = plotFrozenMargin(obj);
        [ ] = add(obj,obj2);
    end
    
end

