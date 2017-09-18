classdef tai2
% tai2输入的数据均为Bars格式的单一资产时间序列
% 调用tai中的函数计算指标
% 如果不用指定输出则画图
% ---------------------------
% ver1.0; Zhang,Hang; 20130424;
% ver1.1; Cheng,Gang; 20130425;   优化格式，正名bars
    
    properties
    end
    
    methods (Access = 'public', Static = true, Hidden = false)
        [sig_long, sig_short]           = Ac(bars, nDay, mDay, type)
         [sig_long, sig_short]          = Alligator(bar, fast, mid, slow, delta, type)
        [ sig_long, sig_short, sig_rs ] = Aroon(bars, nDay, upband, lowband, type)
        [sig_long, sig_short]           = Asi(bar, nBar, type)
        [sig_long,sig_short, sig_rs]    = Bbi(bars, lag1, lag2, lag3, lag4, type)
        [sig_rs]                        = Bias(bars, nDay, type)
        [ sig_long, sig_short, sig_rs]  = Bollinger( bars, wsize, wts, nstd, wlow, type)
        [ sig_rs ]                      = Cci( bars, tp_per, md_per, const, type)
        [ sig_long, sig_short, cle ]    = Cle(bars, mu_up, mu_down)
        [sig_rs]                        = Cmf (bar, nDay, threshold, type)
        [ sig_long, sig_short, sig_rs]  = Dmi( bars, lag, thred, type)
        [sig_rs]                        = Force(bars, nday,thresh, type)
        [sig_long, sig_short, sig_rs]   = Kdj(bar, thred1, thred2, nday, m, l, type)
        [sig_long, sig_short, sig_rs]   = Leadlag(bars, lead, lag, flag, type)
        [ sig_long, sig_short, sig_rs]  = Macd( bars, short, long, compare, type )
        [sig_rs]                        = Mfi(bars, nDay,type)
        [sig_long, sig_short  ]         = Mtm(bars, nDay)
        [ sig_rs ]                      = Obv( bars, type)
        [sig_long, sig_short ]          = Psy(bars, nDay, mDay,type)
        [sig_long, sig_short,sig_rs]    = Pvt(bars, mu_up, mu_down, type)
        [ sig_long, sig_short, sig_rs ] = Rsi(bars, long, short, type)
        [ sig_long,sig_short,sig_rs]    = Sar( bars, step, maxStep, type)
        [sig_long, sig_short, sig_rs]   = Trix (bars, nDay, mDay, type)
        [sig_rs]                        = Tsi (bars, fast, slow, type)
        [sig_long, sig_short]           = Willr(bars, nday, thred1, thred2, type)
    end
end