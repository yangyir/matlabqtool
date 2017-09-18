function [sig_rs] = Cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay,threshold,type)
% Chaikin Money Flow 返回强弱信号
% daniel 2013/4/2

%% 预处理

[nPeriod, nAsset] = size(ClosePrice);
sig_rs = zeros(nPeriod,nAsset);

if ~exist('threshold', 'var') || isempty(threshold), threshold = 0.05; end
if ~exist('nDay', 'var') || isempty(nDay), nDay = 20; end
if ~exist('type', 'var') || isempty(type), type = 1; end
threshold = abs(threshold);
%% 计算步

cmfVal = ind.cmf ( HighPrice, LowPrice, ClosePrice, Volume, nDay);


%% 信号步
% cfm大于阈值时，表示超买，预示后期市场下跌
% 相反，小于阈值时，表示超卖，预示后期上涨
if type==1
sig_rs(cmfVal<-threshold) =  1;
sig_rs(cmfVal>threshold)  =  -1;
else
;
end
end %EOF
