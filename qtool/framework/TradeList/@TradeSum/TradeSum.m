classdef TradeSum<handle
% ���������ͳ��һ��ʱ���ڣ���һ�죬��һ�ܣ��Ľ��ײ���
% ����properties���Ǳ���
    
    % v1.0,���䳬��20131018
    % v1.1,���䳬��20131119
    %    1. �����˳ֲ�ʱ��������
    %    2. ������add�������������tradeSum�ĺϲ���
    %    3. ������genTradeSum���������ڴ�PairedTradeList��tradeSum�����ɡ�
    % v1.2�����䳬��20140725
    %    1. ������calcByRound����
    % v1.3, ���䳬��20140814
    %    1. �޸���calcByRound ���
    
    %%
    properties
        % ���ڽ��״�����ͳ��
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
        
        % ���ڽ�������ͳ��
        TradeVol;
        WinVol;
        LoseVol;
        LongVol;
        ShortVol;
        LongWinVol;
        LongLoseVol;
        ShortWinVol;
        ShortLoseVol;
        
        % ��������ͷ��յ�ͳ��
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
        
        
        % ���ڳֲ�ʱ���ͳ��
        AvgHoldingPeriod;
        AvgWinHoldingPeriod;
        AvgLoseHoldingPeriod;
        AvgLongHoldingPeriod;
        AvgShortHoldingPeriod;
        
        % ����
        avgSlippage;
    end
    
    %%
    methods
        function obj = TradeSum()
            obj.setZero();
        end
        
        
        function [tradeSumTable] = output(obj)
        % ����    
            tradeSumTitle = fieldnames(obj);
            tradeSumValue = struct2cell(obj);
            tradeSumTable = [tradeSumTitle,tradeSumValue];
        end
        
        
        function [ obj ] = calcConWLN(obj, pnl )
        % ����ӯ������
            
            % V1.0�����䳬��20131021
            % V2.0, ���䳬��20131123
            %    1. ���뵽TradeSum��
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

