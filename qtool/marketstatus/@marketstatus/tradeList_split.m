function [ FluxtradeList, TrendtradeList ] = tradeList_split( bars, tradeList, account, FluxInd, TrendInd)
% v 1.0 by Yang Xi 2013/7/3
% 此函数将tradeList按照盘整段和趋势段的序号进行进行切割
% bars 为原始的bar
% tradeList是利用backtest函数对于此bar的交易列表
% FluxInd是盘整阶段的序号
% TrendInd是趋势阶段的序号

time = bars.time;
flux_time = time(FluxInd);
trend_time = time(TrendInd);
FluxtradeList = [];
TrendtradeList = [];
FluxSignal = zeros(1, length(time));
TrendSignal = zeros(1, length(time));
FluxSignal(FluxInd) = 1 ;
TrendSignal(TrendInd) =1 ;

for i = 1:length(tradeList(:,1))
    if ismember(tradeList(i,3),flux_time)==1 && ismember(tradeList(i,4),flux_time)==1
        FluxtradeList = [FluxtradeList; tradeList(i,:)];
    else if ismember(tradeList(i,3),trend_time)==1 && ismember(tradeList(i,4),trend_time)==1
            TrendtradeList = [TrendtradeList; tradeList(i,:)];
        else if ismember(tradeList(i,3),flux_time)==1 && ismember(tradeList(i,4),trend_time)==1 % 本交易前半部分属于盘整，后半部分属于趋势
                flux_startTime = tradeList(i,3);
                flux_enterIndex = find(abs(time-flux_startTime)<1e-16);
                flux_exitIndex = flux_enterIndex+find(FluxSignal(flux_enterIndex:end)==0,1,'first')-2;
                flux_endTime = time(flux_exitIndex);
                FluxtradeRet = account(flux_exitIndex)./account(flux_enterIndex-1)-1;
                FluxtradeList = [FluxtradeList; [FluxtradeRet tradeList(i,2) flux_startTime flux_endTime]];
                trend_startTime = time(flux_exitIndex+1);
                trend_enterIndex = flux_exitIndex+1;
                trend_exitIndex = find(abs(time-tradeList(i,4))<1e-16);
                trend_endTime = tradeList(i,4);
                TrendtradeRet = account(trend_exitIndex)./account(trend_enterIndex-1)-1;
                TrendtradeList = [TrendtradeList; [TrendtradeRet tradeList(i,2) trend_startTime trend_endTime]];
            else if ismember(tradeList(i,3),trend_time)==1 && ismember(tradeList(i,4),flux_time)==1 % 本交易前半部分属于盘整，后半部分属于趋势
                    trend_startTime = tradeList(i,3);
                    trend_enterIndex = find(abs(time-trend_startTime)<1e-16);
                    trend_exitIndex = trend_enterIndex+find(TrendSignal(trend_enterIndex:end)==0,1,'first')-2;
                    trend_endTime = time(trend_exitIndex);
                    TrendtradeRet = account(trend_exitIndex)./account(trend_enterIndex-1)-1;
                    TrendtradeList = [TrendtradeList; [TrendtradeRet tradeList(i,2) trend_startTime trend_endTime]];
                    flux_startTime = time(trend_exitIndex+1);
                    flux_enterIndex = trend_exitIndex+1;
                    flux_exitIndex = find(abs(time-tradeList(i,4))<1e-16);
                    flux_endTime = tradeList(i,4);
                    FluxtradeRet = account(flux_exitIndex)./account(flux_enterIndex-1)-1;
                    FluxtradeList = [FluxtradeList; [FluxtradeRet tradeList(i,2) flux_startTime flux_endTime]];
                else
                    disp('error');
                end
            end
        end
    end
end
end


