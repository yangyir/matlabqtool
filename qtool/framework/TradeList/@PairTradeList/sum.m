function [  ] = sum( obj,config,timeTs,priceTs)
%SUM Summary of this function goes here
%   Detailed explanation goes here

% 潘其超，20140706，V1.0
% 潘其超，20140708，V2.0
%    1. 修改入参，加入最大潜在盈利，最大潜在亏损的计算
% 潘其超，20140714，V3.0
%    1. 修正最大潜在亏损，盈利的一处计算

flagTsCalc = false;
if nargin == 4
    % 尚未对tick编号
    if obj.data(1,obj.tickI)==0||isnan(obj.data(1,obj.tickI))
        for iTrade = 1:obj.rcdNum
            obj.data(iTrade,obj.tickI) = find(timeTs>=obj.data(iTrade,obj.timeI),1,'first');
        end
    end
    
    flagTsCalc = true;
end


for iTrade = 1:2:obj.rcdNum
    instrIdx = config.instrType == obj.data(iTrade,obj.instrumentNoI);
    cmsnRate =config.cmsnRate(instrIdx);
    mltplr = config.multiplier(instrIdx);
    % 计算损益
    obj.data(iTrade,obj.pnlI) =  (obj.data(iTrade+1,obj.priceI)- obj.data(iTrade,obj.priceI))...
        *obj.data(iTrade,obj.volumeI)*mltplr*obj.data(iTrade,obj.directionI);
    
    % 计算手续费, 此处包含了tradeID为0, NaN, 大于0的情况，tradeID小于0为非法，但是此处不能辨别。
    if obj.data(iTrade,obj.tradeIDI)>0
        obj.data(iTrade,obj.cmsnI) = obj.data(iTrade,obj.priceI)*obj.data(iTrade,obj.volumeI)*mltplr*cmsnRate;
    end
    
    if obj.data(iTrade+1,obj.tradeIDI)>0
        obj.data(iTrade+1,obj.cmsnI) = obj.data(iTrade+1,obj.priceI)*obj.data(iTrade+1,obj.volumeI)*mltplr*cmsnRate;
    end
    
    % 计算持仓时间
    obj.data(iTrade,obj.spanI) = obj.data(iTrade+1,obj.timeI) - obj.data(iTrade,obj.timeI);
    
    if flagTsCalc
        % 计算最大潜在盈利与最大潜在亏损
        maxPrice = max(priceTs(obj.data(iTrade,obj.tickI):obj.data(iTrade+1,obj.tickI),instrIdx));
        minPrice = min(priceTs(obj.data(iTrade,obj.tickI):obj.data(iTrade+1,obj.tickI),instrIdx));

        deltaA= (maxPrice- obj.data(iTrade,obj.priceI))...
            *obj.data(iTrade,obj.volumeI)*mltplr*obj.data(iTrade,obj.directionI);

        deltaB = (minPrice- obj.data(iTrade,obj.priceI))...
            *obj.data(iTrade,obj.volumeI)*mltplr*obj.data(iTrade,obj.directionI);

        if deltaA>=deltaB
            obj.data(iTrade,obj.maxProfitI) = deltaA;
            obj.data(iTrade,obj.maxLossI) = deltaB;
        else
            obj.data(iTrade,obj.maxProfitI) = deltaB;
            obj.data(iTrade,obj.maxLossI) = deltaA;
        end
    end
end

end

