classdef EntrustList<TEBase
    %ENTRUSTLIST 委托记录，属核心类
    
    % 潘其超，20140618，V1.0
    % 潘其超，20140725，V2.0
    %   1. 将eval表达式简化。
    % 潘其超，20140729，V3.0
    %   1. 加入了交易专用方法updEntrustItem
    % 程刚，20140805，V4.0
    %   1. 加入headers域，toTable，toExcel方法
    % 潘其超，20140806，V5.0
    %   1. delete headers, ELVecNames;
    %   2. 删除toTable, toExcel 方法。
    %   3. delete extend, prune 方法。
    % 程刚，20140806，V5.1
    %   1，把toTable，toExcel方法移入父类TEBase中
    
    
    
    
    %% 以下均为N×1向量
    properties
        orderType;      % 委托类型, market, limit, stop, fok etc.
        orderStatus;    % 委托状态
        tradeVolume;    % 成交数目
        cancelVolume;   % 撤单数量
        tradeNum;   % 成交笔数
        recvTime;   % 后台系统接收时间
        cancelTime; % 撤单时间
        updateTime; % 最后修改时间
        currTick;   % 信号对应的当前tick信息
        nextTick;   % 信号对应的下一个tick信息
        currBar;    % 信号对应的当前bar信息
        nextBar;    % 信号对应的下一个bar信息
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
    
    %% 交易专用
    methods
        function [] = updEntrustItem(obj,newEntrust,instrumentCode)
            
            % 潘其超，20140725，V1.0
            % 潘其超，20140804，V2.0
            %    1. 加入了对roundNo，combNo的更新。
            
            
            flagNew = false;
            % 首先判断该Entrust是否已经存在
            if obj.latest ~= 0
                ind = obj.entrustNo(1:obj.latest)==newEntrust.entrustNo;
                if ~any(ind)
                    % 新单
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

