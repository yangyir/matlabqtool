function [sig_long, sig_short] = Willr(bars, nday, thred1, thred2, type)
%计算williams值以及对应的交易信号(-1,0,1)
%输入 ClosePrice,HighPrice,Lowprice,n,其中，n表示周期的长度
%输出 pos 交易信号，willr 计算的willr值
%   Yan Zhang   version 1.0 2013/3/12

%willr>-20, 超买状态，行情见顶，信号为-1
%willr<-80, 超卖状态，行情见底，信号为1 
%   Yan Zhang   version 1.1 2013/3/21
if ~exist('nday', 'var') || isempty(nday), nday = 14; end
if ~exist('type', 'var') || isempty(type), type = 1; end

ClosePrice = bars.close;
HighPrice = bars.high;
LowPrice = bars.low;

[sig_long, sig_short] = tai.Willr(ClosePrice, HighPrice, LowPrice, nday, thred1, thred2, type);

if nargout == 0
    willr.willr = ind.willr(HighPrice, LowPrice, ClosePrice, nday);
    bars.plotind2(sig_long + sig_short, willr, true);
    title('willr rs');
end
end