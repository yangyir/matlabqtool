function [sig_long, sig_short] = Willr(ClosePrice,HighPrice,LowPrice,nday,thred1, thred2, type)
%计算williams值以及对应的交易信号(-1,0,1)
%输入
%【数据】ClosePrice,HighPrice,Lowprice
%【参数】 nday移动平均回溯天数（自然数）
%输出交易信号
%   Yan Zhang   version 1.0 2013/3/12

%willr>-20, 超买状态，行情见顶，信号为-1
%willr<-80, 超卖状态，行情见底，信号为1 
%   Yan Zhang   version 1.1 2013/3/21

%% 预处理
if nargin <3
    error('not enough input');
end


if ~exist('nday', 'var') || isempty(nday), nday = 14; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算willr值
willrval = -ind.willr( HighPrice, LowPrice, ClosePrice,nday);

%% 计算信号
if type==1
    sig_long = double(crossOver(willrval, thred1 * ones(size(willrval)), 1));
    sig_short = -crossOver(thred2*ones(size(willrval)), willrval, 1);
else

end