function [ sig_long,sig_short, sig_rs] = Rsi(price, long, short,type)
%% 函数输出 RSI 及其决定的强弱信号;
% rsi 为量能指标，因此只输出强弱信号；
% 输入 price 为每日收盘价；
% 输入 long，short 用来计算不同周期下的 rsi
% 输出为强弱信号 sig_rs 以及 rsi

%% 变量预处理以及初始化
if ~exist('long', 'var') || isempty(long), long = 14; end
if ~exist('short', 'var') || isempty(short), short = 7; end
if ~exist('type', 'var') || isempty(type), type=1; end

[nPeriod, nAsset] = size(price);
sig_long   =  zeros(nPeriod,nAsset);
sig_short   =  zeros(nPeriod,nAsset);
sig_rs = zeros(nPeriod, nAsset);

%% 针对不同资产求解信号以及指标结果
rsi_long = ind.rsi(price, long);
rsi_short = ind.rsi(price, short);

%% 计算信号
if type==1
     sig_long(crossOver(ones(nPeriod, nAsset)*30, rsi_long)) = 1;
     sig_short(crossOver(rsi_long, ones(nPeriod, nAsset)*70)) = -1;
     sig_rs(rsi_long > 70) = -1;
     sig_rs(rsi_long < 30) = 1;   
elseif type==2
    %当rsi短期上穿且小于80，或者直接小于20的时候买入
    %当rsi短期下穿且小于80，或者直接大于80的时候卖出
    sig_long(   crossOver(rsi_short,rsi_long)    & rsi_short< 80 | rsi_short <20) = 1;
    sig_short(  crossOver(rsi_long, rsi_short)  & rsi_short >20 | rsi_short >80) = -1;
    sig_rs(rsi_short    >   rsi_long   &   rsi_short   < 80    | rsi_short< 20) = 1;
    sig_rs(rsi_short    <   rsi_long   &   rsi_short   > 20    | rsi_short > 80) =-1;
else
    ;
end

end
