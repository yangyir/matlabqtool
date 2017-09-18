function  [sig_long, sig_short, sig_rs] = Leadlag(price, lead, lag, flag,type)
% 领先落后指标，用2条移动平均线预测价格趋势，给出交易信号
% daniel 2013/3/1
% price：（多个）资产价格序列
% lead：快速移动均线
% lag： 慢速移动均线
% flag：移动均线算法

%% 检查数据及预留输出空间
if nargin <1 || isempty(price)
    error('no input found')
end
if ~exist('type', 'var') || isempty(type), type = 1; end
if ~exist('lead', 'var') || isempty(lead), lead = 10; end
if ~exist('lag', 'var') || isempty(lag), lag = 30; end
if ~exist('flag', 'var') || isempty(lag), flag = 'e'; end
[nPeriod, nAsset] = size(price);

%%
sig_long     = zeros(nPeriod, nAsset);
sig_short    = zeros(nPeriod, nAsset);
sig_rs       = zeros(nPeriod, nAsset);

%%
% 计算快速线和慢速线
[leadVal, lagVal]=ind.leadlag(price,lead,lag,flag);

%%
if type==1
% 按照快速线上穿慢速线以及快速线是否向上作为买卖依据
sig_long(crossOver(leadVal, lagVal))  = 1;
sig_short(crossOver(lagVal, leadVal)) = -1;

% 计算强弱信号
sig_rs(leadVal >  lagVal)  =  1;
sig_rs(leadVal <= lagVal)  = -1;

else
    ;
end
end %[EOF]

