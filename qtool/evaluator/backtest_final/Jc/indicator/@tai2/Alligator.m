function [sig_long, sig_short] = Alligator(bar, fast, mid, slow, delta, type)
%计算alligator方法以及对应的交易信号(-1,0,1)
%输入 
%【数据】ClosePrice,HighPrice
%【参数】 判决相对高低的阈值delta=0.01;
% 输出 
%pos 交易信号，以及alligator三条均线值 linegreen linered lineblue 分别为 5日 8日 13日sma
%   Yan Zhang   version 1.0 2013/3/12
%
%延时小的线比延时大的线相对高出一个阈值，sig_long信号为1
%延时大的线比延时小的线相对低出一个阈值, sig_short信号为-1
%Yan Zhang   version 1.1 2013/3/21

% 预处理
if ~exist('delta','var') || isempty(delta), delta = 0.01; end
if ~exist('type','var') || isempty(type), type = 1; end
if ~exist('fast', 'var') || isempty(fast), fast = 3; end
if ~exist('mid', 'var') || isempty(mid), mid = 7; end
if ~exist('slow', 'var') || isempty(slow), slow = 15; end

highPrice = bar.high;
lowPrice = bar.low;
closePrice = bar.close;

[sig_long, sig_short] = tai.Alligator(highPrice,lowPrice,closePrice, fast, mid, slow, delta,type);


if nargout == 0
    [alligatorline.linegreen, alligatorline.linered, alligatorline.lineblue] = ...
        ind.alligator(highPrice, lowPrice, fast, mid, slow);
    bar.plotind2(sig_long + sig_short, alligatorline);
end

end

