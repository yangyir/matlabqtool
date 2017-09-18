classdef evl
% 算风险收益指标计算函数包，核心函数包
% 本类只作为一个函数包，全部是static函数，没有properties
% 全部是元函数，入参出参都是简单数据类型
% ---------------------------
% Pan, Qichao; 2013; 好久没用过
% 程刚，20150510，名字改为evl，避免eval
% 程刚，20150517，加入
%     [hfig] = plotSimple(nav,benchmark);
%     [hfig] = plotNavBmk(nav,benchmark);
% 程刚，20150530，加入 [txt, txt2] = rptSimple( nav, rfr, period, benchmark );


    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        % 已查，无误
        
        % nav  <--> yield
        [ nav ]     = yield2nav( yield, flag );
        [ yield ]   = nav2yield( nav,   flag );
        
        % 基本指标计算
        [ aYield ]      = annualYield( nav, period);
        [ aVol ]        = annualVol( nav, period);        
        maxConGainTime  = maxConGainTime( nav);
        [mddVal, idx]   = maxDrawDownVal(nav);
        [ mdd ]         = maxDrawDown( nav );
        [ preHi, idx ]  = preHigh( nav );
        [ span, t1, t2] = longestDrawDown( nav );
        

        
        % 复杂指标，ratio指标计算
        alpha   = alpha( nav, benchmark, rf,period);
        beta    = beta( nav, benchmark);
        sharpeR = SharpeRatio( nav, rf, period);
        calmarR = CalmarRatio( nav, rf, period);
        
        
        % 唐一鑫已改


        
        % 已查，有误，基本都在年化上有误
        burkeR  = BurkeRatio(nav, rf);
        sortinoR = SortinoRatio( nav, rf);
        treynorR = TreynorRatio( nav, benchmark, rf);
        infoRatio = InfoRatio( nav, benchmark);

        % 未查， 暂有不懂
        lretExclMax = LretExclMax(navOrRate, flag)
        retExclMax  = RetExclMax(navOrRate, flag)
        upRatio = upr(ret, MAR);
        
        % 程刚新加

        
        % 唐一鑫新加

        
        
        
        % TODO: 写nav2yield， yield2nav
        % 唐一鑫来做

        [ annualY ] = Annualize( yield, flag);

        
    end
    
    %% 画图函数和简单报告和复杂报告
    methods (Access = 'public', Static = true, Hidden = false)
        
        [ hfig ]    = plotSimple(nav, rfr, period, benchmark);
        [ hfig ]    = plotNavBmk(nav, benchmark);
        
        %[txt, txt2] = rptSimple( nav, rfr, period, benchmark );
       [ txt, txt2 ] = rptSimple( nav, varargin);
       
       % 比较复杂的报告
       [] = reportWord(xlsFilename, period);
       [] = reportWord2(xlsFilename);

    end
    
end

