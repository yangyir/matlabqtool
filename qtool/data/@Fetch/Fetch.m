classdef Fetch
% 取数据的方法在这里
% TODO：把常见的过程写进去，参数放在config里；达到目标：run一遍，自动更新各个库
% TODO: 取tick数据的方法
% TODO：从SQLserver取数据的方法
% 程刚，20131210；加入了从DataHouse取数据的方法，都是static
% 程刚，20151219，加入期权部分
% 朱江，20160308, 加入从DataHouse中取QuoteOpt的方法。


    properties
        config;
    end
    
    
    %% 依赖DataHouse的方法
    methods (Static = true )
        % 取Bars的方法
        [ bs ] = dhBars( secID, start_date, end_date, slice_seconds, config );       
        [ bs ] = dhStockBars( secID, start_date, end_date, slice_seconds, fuquan );
        [ bs ] = dhFutureBars( futID, start_date, end_date, slice_seconds);

        % 从dh取Option Bars
        [ bs ] = dhOptionBars( optID, start_date, end_date, slice_seconds);
        
        % 从dh中取QuoteOpt
        [ optQuote] = dhFillOptQuote( optQuote, query_date, query_time);
        
        [ bs ]  = dhStockDBars(  secID, start_date, end_date, slice_days, fuquan  );
        
        
        % 从dh取Stock Ticks
        [ tks, Sflag ] = dhStockTicks(code, tday, levels);
        
        % 从dh取Future Ticks
        [ tks, Sflag ] = dhFutureTicks(code, tday, levels);
        
        
         % 从dh取Option Ticks
        [ tks, Sflag ] = dhOptionTicks(code, tday, levels);
        
        
    end
    
    
    
    %% 常用方法，视作方法容器
    methods (Static = true )        
        % 从db取Bars
        [ bs, Sflag ] = dbBars(code, start_date, end_date, slice_seconds, slice_start, levels);
                
        % 从db中取股票日度数据
        [bs, Sflag] = dbStockDaily(code,startDate,endDate,fuquan,date);
        
        % 从db中取股票分钟数据
        [minBars, Sflag] = dbStockBars(code,startDate,endDate,sliceMinutes, fuquan,date);       
        
        % 从db取Ticks
        [ tks, Sflag ]  = dbTicks(code, start_date, end_date, levels);        
        
        
        
        % 国泰安Tick数据， 暂时以未放入数据库中， 以mat文件存储 HeQun 2014.1.22
        [ tks, sFlag ] = dmTicks(code, start_date, end_date, driver);
        
        % 国泰安Bar数据， 切割Tick数据获取 HeQun 2014.1.22
        [ bs, sFlag ] = dmBars(code, start_date, end_date, slice_seconds, slice_start, driver);
        
        
        
        [ bs ] = futureBars( futID, start_date, end_date, slice_seconds) ; 
        
        [ bs ] = stockBars( secID, start_date, end_date, slice_seconds, fuquan )
    end
    

    %% 把各种script写在这里，视作script容器
    methods( Access = protected )
        [ bs, Sflag ] = dbDayBars(conn, secID, req_date, slice_seconds, slice_start, levels, type);
        [ ts, Sflag ]   = dbDayTicks(conn, secID, req_date, levels, type);
        [ bs, success ] = dmDayBars(secID, reqDate, sliceSeconds, sliceStart, driver);
        [ ts, Sflag ] = dmDayTicks(secID, req_date, driver);
        [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date)

    end
    
    
end

