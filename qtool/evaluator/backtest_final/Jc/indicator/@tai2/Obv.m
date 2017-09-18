function [ sig_rs ] = Obv( bar, type)
%% 该函数用来计算 OBV 以及所对应的强弱信号 ； 
% OBV 属于量能指标
% 输入 close, vol 分别为当日的收盘价以及交易量；
% 输出 sig_rs 为交易的强弱信号；
% 输出 obv 为指标的数值；

%% 变量预处理与初始化
close = bar.close;
vol = bar.volume;
% 建立长短周期
long  = 20;
short = 5;
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算 obv 以及对应的信号；
sig_rs = tai.Obv(close, vol, type);

if nargout == 0
    obv.obv = ind.obv(close, vol);
    bar.plotind2(sig_rs, obv, true);
    title('sig rs');
end

end

