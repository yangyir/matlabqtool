
classdef tai
    %TAI 调用ind类计算指标，产生对应的信号。type=1时为默认信号的产生方法。
    %输出中仅包括信号，如果需要具体的指标，请调用ind类的函数
    %Cma，Ma， Atr中不产生信号。
    %2013/4/23     yanzhang     
    %
    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        [sig_long, sig_short] = Ac(HighPrice,LowPrice,nDay,mDay, type)
        [sig_long, sig_short] = Alligator(HighPrice,LowPrice,ClosePrice,delta,type)
        [ sig_long, sig_short, sig_rs] = Aroon(high,low,nDay, upband, lowband,type)
        [sig_long, sig_short] = Asi(open, high, low, close, mu_up, mu_down,type)
        [atr] = Atr( high, low, close, nDay)
        [sig_long,sig_short, sig_rs] = Bbi(close, lag1, lag2, lag3, lag4,type)
        [sig_rs] = Bias(close,nDay,type)
        [ sig_long, sig_short, sig_rs] = Bollinger( price, wsize, wts, nstd, wnar, pwidth,type)
        [ sig_rs] = Cci( HighPrice, LowPrice, ClosePrice,tp_per,md_per,const,type)
        [ CMA ] = Cma( seq, semi_win ,type)
        [sig_rs] = Cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay,threshold,type)
        [ sig_long, sig_short, sig_rs] = Dmi( highPrice, lowPrice, closePrice, lag, thred,type)
        [sig_rs] = Force(ClosePrice,TradeVol,nday,thresh, type)
        [sig_long,sig_short,sig_rs] = Kdj(ClosePrice,HighPrice,LowPrice,nday,type)
        [sig_long, sig_short, sig_rs] = Leadlag(price, lead, lag, flag,type)
        [ma] = Ma(price,lag,flag)
        [ sig_long, sig_short, sig_rs] = Macd( price, short, long, compare,type)
        [sig_rs] = Mfi(high, low, close, volume, nDay,type)
        [sig_long, sig_short , sig_rs] = Mtm(ClosePrice, nDay)
        [ sig_rs] = Obv( ClosePrice, Volume,type)
        [sig_long, sig_short, sig_rs] = Psy(ClosePrice,nDay, mDay,type)
        [sig_long, sig_short,sig_rs] = Pvt(ClosePrice,Volume, mu_up, mu_down,type)
        [ sig_long,sig_short, sig_rs] = Rsi(price, long, short,type)
        [ sig_long,sig_short,sig_rs] = Sar( high, low, price, step, maxStep,type)
        [sig_long, sig_short, sig_rs] = Trix (close, nDay, mDay,type)
        [sig_rs] = Tsi (close, fast, slow,type)
        [sig_rs] = Willr(ClosePrice,HighPrice,LowPrice,nday,type)
    end
end

