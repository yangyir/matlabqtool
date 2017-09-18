% market status class
% version:v1 Wu Zehui,2013/6/25 :
% add distance,displacement,dist_disp_ratio
% version:v2 Yang Xi, 2013/6/26
% add ContinTrend, GuppyMMA and ContinFilter
% version:v3 Yang Xi, 2013/7/1
% add GuppyTrendIdentify and ContinTrendIdentify
% version:v4 Yang Xi, 2013/7/2
% add BarsSplit
% version:v5 Wu Zehui,2013/7/4
% add
% account_split,tradeList_split,calc_winloserate,calc_netprofit,calc_MaxDrawDown,
% add ContinFilter2
classdef marketstatus
    properties
    end
    methods (Access = 'public', Static = true, Hidden = false)
        dist = distance( bars , window );
        displa = displacement( bars , window );
        dist_disp_ratio = dist_disp_ratio( bars , window );
        [upcount,downcount] = ContinTrend(bars, tol, uppercent, downpercent)
        GuppyRatio = GuppyMMA(bars, period1, period2, period3, period4, period5);
        [FiltLoc, newsignal] = ContinFilter(signal, tol);
        [FluxInd, TrendInd] = GuppyTrendIdentify(bars, period1, period2, period3, period4, period5, tol);
        [UpInd,DownInd,FluxInd] = ContinTrendIdentify(bars, tol1, uppercent, downpercent, tol2);
        newbars = BarsSplit(bars, idx);
        subacc = account_split(ori_account,Ind);
        [ FluxtradeList, TrendtradeList ] = tradeList_split( bars, tradeList, account, FluxInd, TrendInd);
        [winrate,loserate] = calc_winloserate(tradeList);
        netprofit = calc_netprofit(tradeList);
        MaxDrawDown = calc_MaxDrawDown(Account);
        newsignal = ContinFilter2(signal,tol);
    end
end