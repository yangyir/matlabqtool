function [sig_long, sig_short, sig_rs] = Kdj(bar, thred1, thred2, nday, m, l, type)
%计算kdj值以及对应的交易信号(-1,0,1)
%输入 ClosePrice,HighPrice,Lowprice,n,type其中，n表示周期的长度
%type  表示ma计算过程的系数选择方式 
%type 1 [2/3 1/3] type 2 [(n-1)/n 1/n]
%输出 pos 交易信号，kdj 计算的kdj值
%   Yan Zhang   version 1.0 2013/3/12 
%
%   sig_long  当K上穿30时，买入，信号为1 当信号为1且K在70以下，K，D产生死叉，信号改为-1 
%   sig_short 当K下穿70时，卖出，信号为-1 当信号为-1且K在30以上，K，D产生死叉，信号改为-1 
%   sig_rs   K<30，超卖，信号为1，K〉70，超买，信号为-1
%   Yan Zhang   version 1.1 2013/3/12

if ~exist('nday', 'var') || isempty(nday), nday = 9; end
if ~exist('type', 'var') || isempty(type), type = 1; end

[sig_long, sig_short, sig_rs] = tai.Kdj(bar.close, bar.high, bar.low, thred1, thred2, nday, m, l, type);

if nargout == 0
    [kdj.k, kdj.d, kdj.j] = ind.kdj(bar.close, bar.high, bar.low, thred1, thred2, nday, m, l);
    bar.plotind2(sig_long + sig_short, kdj, true);
    title('kdj long and short');
    bar.plotind2(sig_rs, kdj, true);
    title('kdj rs');
end
end