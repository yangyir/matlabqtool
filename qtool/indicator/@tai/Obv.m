function [ sig_rs] = Obv( ClosePrice, Volume,type)
% On-Balance Volume 
% OBV 属于量能指标
% 输入 【数据】 收盘价以及交易量；
% 输出 sig_rs 为交易的强弱信号；
% 输出 obv 为指标的数值；


%% 变量预处理与初始化
[nperiod, nasset]  =  size(ClosePrice);
% 建立长短周期
long  = 20;
short = 5;
if ~exist('type', 'var') || isempty(type), type = 1; end

%% 计算 obv 以及对应的信号；
 obvVal  = ind.obv( ClosePrice, Volume );
% em_obv  =  tai.Ma( obvVal );          % obv 移动平均
% em_sl   =  tai.Ma( ClosePrice, long );  % close 的长期移动平均
% em_ss   =  tai.Ma( ClosePrice, short);  % close 的短期移动平均

em_obv = ind.ma( obvVal ); % obv 移动平均
em_sl = ind.ma( ClosePrice, long ); % close 的长期移动平均
em_ss = ind.ma( ClosePrice, short );% close 的短期移动平均

macd_obv  =  macd( obvVal );          % obv 的 macd 数值
sp_obv  =  obvVal - em_obv;           % obv 以及移动平均的 spread
sp_st   =  em_ss - em_sl;          % 收盘价长短移动平均的 spread
signal  =  zeros( nperiod, nasset);
% 强弱信号的交易规则

if type==1
signal( macd_obv > 0 & sp_obv > 0)  =  -1;  % 类似 obv 向上穿越，表示超买，卖出；
signal( macd_obv < 0 & sp_obv > 0)  =   1;  % 类似 obv 向下穿越，表示超卖，买入；
signal( sp_obv >0 & sp_st <0)  =  1;   % 量能扩大，价格短期下降趋势的时候，买入；
signal( sp_obv <0 & sp_st >0)  = -1;   % 量能缩小，价格短期上升趋势的时候，卖出；
else
;
end
sig_rs  =  signal;
end

