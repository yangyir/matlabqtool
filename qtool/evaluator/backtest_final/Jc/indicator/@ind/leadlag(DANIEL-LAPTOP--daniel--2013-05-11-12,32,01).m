function [leadVal, lagVal]=leadlag(price,lead,lag,flag)

%%
if ~exist('lead', 'var') || isempty(lead), lead = 10; end
if ~exist('lag', 'var') || isempty(lag), lag = 30; end
if ~exist('flag', 'var') || isempty(flag), flag = 'e'; end

%%
% ��������ߺ�������
leadVal = tai.Ma(price, lead, flag);
lagVal  = tai.Ma(price, lag,  flag);
