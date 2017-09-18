classdef ind
    % indicator class
    
    properties
    end
    methods (Access = 'public', Static = true, Hidden = false)
        [ acVal ] = aco( HighPrice , LowPrice , nDay , mDay );
        [ adlVal ] = adl( HighPrice, LowPrice, ClosePrice, Volume );
        [ adoVal ] = ado( HighPrice, LowPrice, OpenPrice, ClosePrice )
        [line1, line2, line3] = alligator(HighPrice,LowPrice, fast, mid, slow);
        [ aroon_up, aroon_down ] = aroon( HighPrice, LowPrice, nDay );
        [ asiVal, siVal ] = asi( OpenPrice, HighPrice, LowPrice, ClosePrice );
        [ atrVal ] = atr( HighPrice, LowPrice, ClosePrice, nDay );
        [ bbiVal ] = bbi( ClosePrice, lag1, lag2, lag3, lag4 );
        [ biasVal ]= bias( ClosePrice, nDay );
        [mid, uppr, lowr ] = bollinger( closePrice, wsize, wts, nstd);
        [ cciVal ] = cci( HighPrice, LowPrice, ClosePrice, nDay, mdDay, const );
        [ choVal ] = chaiko( HighPrice, LowPrice,  ClosePrice, Volume );
        [ chavolVal ] = chavol( HighPrice, LowPrice, nDay, mDay);
        [ cmaVal ] = cma( seq, semi_win );
        [ cmfVal ] = cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay );
        [dmiup dmidown dx adx ]=dmi(highPrice, lowPrice, closePrice, lag);
        [ forceVal ] = force( ClosePrice, TradeVol, nDay );
        [ hhVal ] = hh( HighPrice, nDay )
        [k,d,j] = kdj(ClosePrice,HighPrice,LowPrice,nday, m, l)
        [leadVal lagVal]=leadlag(price,lead, lag, flag);
        [ maVal ] = ma( price,lag, flag );
        [diffVal daeVal barVal]=macd(price,long,short,compare);
        [ mfiVal, pmf, nmf ] = mfi(HighPrice, LowPrice, ClosePrice, Volume, nDay );
        [ mtmVal ] = mtm( ClosePrice, nDay);
        [ llVal ] = ll( LowPrice, nDay )
        [ obvVal ] = obv( ClosePrice, Volume );
        [ psyVal ] = psy( ClosePrice, nDay );
        [ pvtVal ] = pvt( ClosePrice, Volume );
        [ rsiVal, rsVal ] = rsi( ClosePrice, nDay );
        [ rsiVal, rsVal ] = rsi_v2( ClosePrice, nDay, mode);
        [sarval]= sar( high,low,AFstart,AFmax,AFdelta);
        [ kVal, dVal ] = sto( HighPrice, LowPrice,  ClosePrice, k, d, dm );
        [ trixVal, trixMa ] = trix (ClosePrice, nDay, mDay);
        [ tsiVal ] = tsi (ClosePrice, fast, slow);    
        [ willrVal ] = willr( HighPrice, LowPrice, ClosePrice, nDay );
        [ willlVar ] = willl( HighPrice, LowPrice, ClosePrice );
        [ rocVal ] = roc( ClosePrice, nDay );
    end
end