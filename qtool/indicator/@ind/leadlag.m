function [leadVal, lagVal]=leadlag(price,lead,lag,flag)

%%
if ~exist('lead', 'var') || isempty(lead), lead = 10; end
if ~exist('lag', 'var') || isempty(lag), lag = 30; end
if ~exist('flag', 'var') || isempty(flag), flag = 'e'; end

%%
% 计算快速线和慢速线
leadVal = ind.ma(price, lead, flag);
lagVal  = ind.ma(price, lag,  flag);
