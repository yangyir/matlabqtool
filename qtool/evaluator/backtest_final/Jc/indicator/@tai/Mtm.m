function [sig_long, sig_short , sig_rs] = Mtm(ClosePrice, nDay)
% Momemtum 动力指标 
% 返回 sig_long, sig_short, sig_rs
% sig_long: mtm从负变正 = 1; sig_short: mtm 从正变负为0; sig_rs: mtm>0 = 1, mtm <0 = -1;
% nDay 回溯bar数 默认= 10
% @author daniel 20130506

%% 预处理
if ~exist('nDay','var'),    nDay = 10;end

[nPeriod, nAsset] = size(ClosePrice);
mtmVal = ind.mtm(ClosePrice, nDay);

sig_long = zeros(nPeriod, nAsset);
sig_short = zeros(nPeriod, nAsset);
sig_rs = zeros(nPeriod, nAsset);

%% 信号步
zeroline = zeros(nPeriod, nAsset);
sig_long(logical(crossOver(mtmVal,zeroline)))   =  1;
sig_short(logical(crossOver(zeroline, mtmVal))) = -1;
sig_rs(mtmVal > 0 ) = 1;
sig_rs(mtmVal < 0 ) = -1;

end %EOF