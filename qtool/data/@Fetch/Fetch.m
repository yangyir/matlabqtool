classdef Fetch
% ȡ���ݵķ���������
% TODO���ѳ����Ĺ���д��ȥ����������config��ﵽĿ�꣺runһ�飬�Զ����¸�����
% TODO: ȡtick���ݵķ���
% TODO����SQLserverȡ���ݵķ���
% �̸գ�20131210�������˴�DataHouseȡ���ݵķ���������static
% �̸գ�20151219��������Ȩ����
% �콭��20160308, �����DataHouse��ȡQuoteOpt�ķ�����


    properties
        config;
    end
    
    
    %% ����DataHouse�ķ���
    methods (Static = true )
        % ȡBars�ķ���
        [ bs ] = dhBars( secID, start_date, end_date, slice_seconds, config );       
        [ bs ] = dhStockBars( secID, start_date, end_date, slice_seconds, fuquan );
        [ bs ] = dhFutureBars( futID, start_date, end_date, slice_seconds);

        % ��dhȡOption Bars
        [ bs ] = dhOptionBars( optID, start_date, end_date, slice_seconds);
        
        % ��dh��ȡQuoteOpt
        [ optQuote] = dhFillOptQuote( optQuote, query_date, query_time);
        
        [ bs ]  = dhStockDBars(  secID, start_date, end_date, slice_days, fuquan  );
        
        
        % ��dhȡStock Ticks
        [ tks, Sflag ] = dhStockTicks(code, tday, levels);
        
        % ��dhȡFuture Ticks
        [ tks, Sflag ] = dhFutureTicks(code, tday, levels);
        
        
         % ��dhȡOption Ticks
        [ tks, Sflag ] = dhOptionTicks(code, tday, levels);
        
        
    end
    
    
    
    %% ���÷�����������������
    methods (Static = true )        
        % ��dbȡBars
        [ bs, Sflag ] = dbBars(code, start_date, end_date, slice_seconds, slice_start, levels);
                
        % ��db��ȡ��Ʊ�ն�����
        [bs, Sflag] = dbStockDaily(code,startDate,endDate,fuquan,date);
        
        % ��db��ȡ��Ʊ��������
        [minBars, Sflag] = dbStockBars(code,startDate,endDate,sliceMinutes, fuquan,date);       
        
        % ��dbȡTicks
        [ tks, Sflag ]  = dbTicks(code, start_date, end_date, levels);        
        
        
        
        % ��̩��Tick���ݣ� ��ʱ��δ�������ݿ��У� ��mat�ļ��洢 HeQun 2014.1.22
        [ tks, sFlag ] = dmTicks(code, start_date, end_date, driver);
        
        % ��̩��Bar���ݣ� �и�Tick���ݻ�ȡ HeQun 2014.1.22
        [ bs, sFlag ] = dmBars(code, start_date, end_date, slice_seconds, slice_start, driver);
        
        
        
        [ bs ] = futureBars( futID, start_date, end_date, slice_seconds) ; 
        
        [ bs ] = stockBars( secID, start_date, end_date, slice_seconds, fuquan )
    end
    

    %% �Ѹ���scriptд���������script����
    methods( Access = protected )
        [ bs, Sflag ] = dbDayBars(conn, secID, req_date, slice_seconds, slice_start, levels, type);
        [ ts, Sflag ]   = dbDayTicks(conn, secID, req_date, levels, type);
        [ bs, success ] = dmDayBars(secID, reqDate, sliceSeconds, sliceStart, driver);
        [ ts, Sflag ] = dmDayTicks(secID, req_date, driver);
        [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date)

    end
    
    
end
