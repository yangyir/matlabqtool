function [trendsig]=trendsignal(seq,mu1,mu2,delay)
%给出数据中的每一点阈值下的趋势
%输入
% 【数据】seq
% 【参数】左右两边的阈值 mu1,mu2, 延时delay
% 【参考】 广发报告
% X:\5.会议记录&内部资料\培训20130122
% mu1 日线取 20%
% --------------------------------------------
%   Yan Zhang   version 1.0 2013/4/12
% Cheng,Gang;   ver1.1;     20130422; 改了输入量默认值
%% pre-process

% 默认值
if ~exist('mu1', 'var')||isempty(mu1),      mu1 = 0.02; end
if ~exist('mu2', 'var')||isempty(mu2),      mu2 = 0.02; end
if ~exist('delay', 'var')||isempty(delay),  delay = 2; end


%% main 
pv=zeros(length(seq-1),1);

for i=2:length(seq-1)
    pv(i)=peakvalley(seq,i,mu1,mu2);
end
if ~nnz(pv)
    trendsig=zeros(length(seq),1);
    return;
end
[~,trendsig]=trendseries(pv,seq,delay);
end