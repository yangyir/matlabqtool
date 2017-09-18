function [ sig_rs] = Cci( HighPrice, LowPrice, ClosePrice,tp_per,md_per,const,type)
%% 该函数输出 CCI 的强弱信号以及 CCI 的数值
% CCI 刻画了股票是否有超买或者超卖现象，属于动能指标
% 输入 HighPrice,LowPrice,ClosePrice 分别是当日最高价，最低价，收盘价；
% 输入 tp_per 为 tp 计算移动平均时的天数
% 输入 md_per 为 md 计算移动平均时的天数
% 输入 const  为计算系数
% 输出 sig_rs 为指标的强弱信号，为 1，-1，分别为买入，卖出建议
% 输出 cci    为指标 cci 的数值

%% 输入参数的预处理

if ~exist('tp_per', 'var') || isempty(tp_per), tp_per = 20; end
if ~exist('md_per', 'var') || isempty(md_per), md_per = 20; end
if ~exist('const', 'var') || isempty(const), const = 0.015; end
if ~exist('type', 'var') || isempty(type), type = 1; end
nasset = size(ClosePrice,2);
nperiod = size(ClosePrice,1);
sig_rs= zeros(nperiod,nasset);


%% 计算 CCI 以及对应的强弱信号 sig_rs
[ cciVal] = ind.cci( HighPrice, LowPrice, ClosePrice,tp_per,md_per,const );
if type==1
    sig_rs(cciVal>100)  = -1;
    sig_rs(cciVal<-100)  = 1;
else
    sig_rs(cciVal>100)  = -1;
    sig_rs(cciVal<-100)  = 1;
end

end