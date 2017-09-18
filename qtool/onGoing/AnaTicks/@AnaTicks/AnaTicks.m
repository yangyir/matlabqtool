% version 1.0, luhuaibao, 2014.5.30
% 构建尖AnaTicks，对入参ticks全面特征统计




classdef AnaTicks
    
    properties
        
    end
    
    
    %% %%%%  第零类：私有函数，数据对象是普通矩阵 %%%%%%%%%%%%%%%%%%%
    methods (Access = 'private', Static = true, Hidden = true )
        % 计算atr
        [ ATR ] = atr0( high, low, vclose, atrlen )
        
        % 与tao兼容，仅用于此计算
        dist= findFirstEqual(  ts1, ts2, itimes )
        
        % 移动求最大值
        [ r, idx ] = movMax0( ts, len )
        
        % 移动求最小值
        [ r, idx ]  = movingMin0( ticks,len,type )
        
        % 求时间序列的变化
        [ varargout ] = chg0( nday,varargin )
        
        % 求时间序列的百分比变化
        [ varargout ] = pctChg0( nday,varargin )
        
        % 求一个数在数列中排的百分位(chenggang, 140608)
        [ percentile ] = prctileP( vertor, value )
        
        % 对齐两列时间
        [ idx1, idx2, commonTime] = duiqiTime(times1, times2, type, givenTime)
        
    end
    
    
    %% %%%%   第一类:基础计算函数，数据对象是Ticks   %%%%%%%%%%%%%%%
    %%%%%%%%%%  采用  xxxYyyZzz 方式命名
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        % 计算timespent,timespent为给定下单方式下，后验看，成交需等待时间
        [waiting, waiting_tk] = r( ticks,t,limitprice,direction, flag_strict, latency   )
        
        % 计算ATR；
        [ vatr ] = ATR( ticks, atrlen )
        
        % 计算买卖挂单的价差
        [ bid_ask_spread ] = bas(ticks,asklevel, bidlevel);
               
        % 移动求最大值，可求过去的最值和未来的最值
        [ r, idx ]  = movingMax( ticks,len,type )
        
        % 移动求最小值，可求过去的最值和未来的最值
        [ r, idx ]  = movingMin( ticks,len,type )
        
        %PCTCHG 计算涨跌幅百分比
        vchg = pctChg( ticks,len,type )
        
        % CHG 计算涨跌幅
        vchg = chg( ticks,len,type )
        
        % 日度的波动，用std计算
        vvol = vol( ticks, type )
        
        % 移动求vol，计算用std
        vol = movingVol( ticks,len,type )
        
        % 计算两个ticks之间的delta
        deltavalue = delta(Ticks1,Ticks2,AdjustMethod)
        
        % 当前价格是多长过去时间的最大值
        [t, tk] = maxSince( ticks, currentTk, type)
        
        % 当前价格是多长过去时间的最小值
        [t, tk] = minSince( ticks, currentTk, type)
        
        % 互为反函数：计算给定价格所处的百分位数，计算给定百分位的价格值(chenggang, 140608)
        [prct]  = percentileP(ticks, currentTk, valuePrice, win, type)
        [value] = percentileV(ticks, currentTk, percentile, win, type)
        
        % 未来一段时间内的最大值，及位置
        [mx,tk,t] = maxof( ticks, currentTk, len, type)
        
        % 未来一段时间内的最小值，及位置
        [mx,tk,t] = minof( ticks, currentTk, len, type)
        
        % 算配对交易的spread
        [ spread, spTicks ] = pairSpread(ticks1, ticks2, type, timeType, commonTime)
    end
    
    %% %%%% 第二类：单一展示函数 （独立的一个分析、展示），可能被调用 %%%%%%%%%%%%
    %%%%%%% 采用 xxx_xxx_xxx命名
    
    methods (Access = 'public', Static = true, Hidden = false)
        
        % 在command中输出，ticks中的last较bid、last较ask的高低关系
        highLowRelation( ticks ) ;
        
        % 统计lask，bid1，ask1的大小关系, 跟上一个功能一样
        [ ratio ] = last_bid_ask_relation(ticks, displayFlag);
         
        % hist买卖挂单的价差
        histBas( ticks, asklevel, bidlevel )
        
        % bid,ask,bas画图
        plotBas( ticks ) ;
        
        % 成交价 vs volume
        plot_lastVolume( ticks )
        
        % last/bid/ask一阶差分分布
        histDiff( ticks )
        
        % 画盘口挂单情况
        plot_orderDepth( ticks ,cur, twindow  );
        
        % 画cur前后若干个tk的挂单情况
        [ ] = plotPanKou( ts, cur, pre_win, post_win );
        
        %% 动画
        % 动画展示盘口数据（单图）
        [] = animate_pankou(ticks, stk, etk, step, pauseSec);
        
        % 动画展示盘口数据(右图）和价格线数据（左图）
        [] = animate_line_pankou(ticks, stk, etk, step, twindow, pauseSec);
        
         
        
    end
    
    
    
    %% %%%%    第三类：应用层次：script，调用第一类和第二类，自动实现功能
    %%%%%%%%%%%         特异性高，不期望被别的程序调用（最终级）
    %%%%%%% 采用 xxx_xxx_xxx命名
    % 早期尽量避免在这一层里加东西
    % 加入的代码应该比较稳定、全面
    
    methods (Access = 'public', Static = true, Hidden = false)

        
        
        % 配合onenote：spread张口和闭口的方式
        ana_spread_enlarge_close(params)
        
        % 计算一整天的r，可进行限价等待时间研究
        taovalue = tao( ticks0 , yields )
        
        % 与taovaluez对应，进行plot
        plotTao( tao,minSpread ) ;
        
        % 期权参数估计
        estimate_Opt( dataPath ) ; 
        
        
        
        %% cg：其实与Ticks无关，暂时放在这里
        % 看跨期套利价差，日度
        dh_daily_IF_time_spread(inear, ifar);
        
        % 
        
        
        
    end
    
    
    
end
