%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于计算各证券买卖时点的序号。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_b,output_s, output_shortb, output_shorts] = calc_buysellmark(signal,configure)
% 预处理与初始化
nPeriod  =  size(signal, 1);
output_b{1}  =  zeros(nPeriod,1);
output_s{1}  =  zeros(nPeriod,1);
output_shortb{1}  =  zeros(nPeriod,1);
output_shorts{1}  =  zeros(nPeriod,1);
lag = configure.lag;

% 将信号分为 sig_long, sig_short 两种，针对做多和做空分别记录
% 信号向后顺延一个单位
signal  =  [zeros(lag,1); signal(1:end - lag)];
sig_long  =  zeros(nPeriod, 1);
sig_short =  zeros(nPeriod, 1);
sig_long(signal > 0)  =  signal(signal > 0);
sig_short(signal< 0)  =  signal(signal < 0);

% 计算信号（可以是实数）差值，也分为做多和做空两种
spread_long  =  sig_long - [0;sig_long(1:end-1)];
spread_short =  sig_short- [0;sig_short(1:end-1)];

% 记录信号
% output_b 里面正数为加多仓，负数为加空仓
output_b{1}(spread_long > 0)  =  spread_long(spread_long > 0);
output_shortb{1}(spread_short< 0)  =  spread_short(spread_short<0);
% output_c 里面正数为平空仓，负数为平多仓
output_s{1}(spread_long < 0)  =  spread_long(spread_long < 0);
output_shorts{1}(spread_short> 0)  =  spread_short(spread_short>0);

end