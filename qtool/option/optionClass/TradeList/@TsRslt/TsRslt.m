classdef TsRslt<handle;
    %TSRES presents the trade report as time series.
    
    % 潘其超，20140701，V1.0
    
    % 潘其超，20140710，V2.0
    %    1. 加入采样频率域，以及自动计算。
    %    2. 加入初始净值。如果没有给定初始净值，按照最大资金占用的2倍计算
    %    3. 加入了RNR域,calcRNR 方法，以及计算sharpe，calmar，drawdown的私有函数。
    %    4. 加入了plotNavVec 方法。
    
    properties
        % 时间标尺
        time;
        % 合约类型
        instrType;
        % 手续费率
        cmsnRate;
        % 保证金比率
        marginRate;
        % 合约乘数
        multiplier;
        % 采样频率
        timeFrequency;
        % 初始净值
        initNav;
        % return and risk
        RNR;
        
        % 以下以Arr结尾的都是time×instr 的矩阵形式
        % 累计pnl矩阵
        cumPnlArr;
        % 仓位矩阵
        posArr;
        % 累计佣金矩阵
        cumCmsnArr;
        % 峰值仓位
        maxPosArr;
        % 冻结资金矩阵
        frozenMarginArr;
        
        % 以下以Vec结尾的是不区分标的向量形式
        cumPnlVec;
        cumCmsnVec;
        frozenMarginVec;
        
    end
    
    methods
        function obj = TsRslt(timeTs,TL,config,timeFreq)
            obj.time = timeTs;
            % 做成行向量
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
                        % 日级别
                        obj.timeFrequency = sprintf('%dday',tmpFreq);
                    elseif tmpFreq>=0.98/1440
                        % 分钟级别
                        obj.timeFrequency = sprintf('%dmin',round(tmpFreq*1440));
                    elseif tmpFreq>=0.98/86400
                        % 秒级
                        obj.timeFrequency = sprintf('%dsnd',round(tmpFreq*86400));
                    else
                        % 毫秒级
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
            % 要求至少有一天的数据
            % 第一天的数据要完整的。
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

