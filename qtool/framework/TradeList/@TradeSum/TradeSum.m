classdef TradeSum<handle
% 这个类用于统计一段时间内（如一天，或一周）的交易参数
% 所有properties都是标量
    
    % v1.0,潘其超，20131018
    % v1.1,潘其超，20131119
    %    1. 加入了持仓时间的五个域。
    %    2. 加入了add方法，用于另个tradeSum的合并。
    %    3. 加入了genTradeSum方法，用于从PairedTradeList到tradeSum的生成。
    % v1.2，潘其超，20140725
    %    1. 加入了calcByRound方法
    % v1.3, 潘其超，20140814
    %    1. 修改了calcByRound 入参
    
    %%
    properties
        % 基于交易次数的统计
        TradeNum;
        WinNum;
        LoseNum;
        LongNum;
        ShortNum;
        LongWinNum;
        LongLoseNum;
        ShortWinNum;
        ShortLoseNum;
        maxConWinNum;
        maxConLoseNum;
        
        % 基于交易量的统计
        TradeVol;
        WinVol;
        LoseVol;
        LongVol;
        ShortVol;
        LongWinVol;
        LongLoseVol;
        ShortWinVol;
        ShortLoseVol;
        
        % 基于收益和风险的统计
        PNL;
        Profit;
        maxSingleProfit;
        Loss;
        maxSingleLoss;
        PPT;
        LPT;
        WinRatio;
        PLRatio;
        Commission;
        annYield;
        annSharpe;
        
        
        % 基于持仓时间的统计
        AvgHoldingPeriod;
        AvgWinHoldingPeriod;
        AvgLoseHoldingPeriod;
        AvgLongHoldingPeriod;
        AvgShortHoldingPeriod;
        
        % 滑点
        avgSlippage;
    end
    
    %%
    methods
        function obj = TradeSum()
            obj.setZero();
        end
        
        
        function [tradeSumTable] = output(obj)
        % 建表    
            tradeSumTitle = fieldnames(obj);
            tradeSumValue = struct2cell(obj);
            tradeSumTable = [tradeSumTitle,tradeSumValue];
        end
        
        
        function [ obj ] = calcConWLN(obj, pnl )
        % 连续盈亏次数
            
            % V1.0，潘其超，20131021
            % V2.0, 潘其超，20131123
            %    1. 加入到TradeSum类
            obj.maxConWinNum    = max(diff([0;find(pnl<0);length(pnl)+1]))-1;
            obj.maxConLoseNum   = max(diff([0;find(pnl>0);length(pnl)+1]))-1;
        end
    end
    %%
    methods (Static = true)
        [obj]   = calcByRound( PTL,mode );
    end
    
    %%
    methods
        []   = setZero(obj);
        
        []   = add(obj,obj2);

          
    end
end

