function [trendsig]=trendsignal(seq,mu1,mu2,delay)
%���������е�ÿһ����ֵ�µ�����
%����
% �����ݡ�seq
% ���������������ߵ���ֵ mu1,mu2, ��ʱdelay
% ���ο��� �㷢����
% X:\5.�����¼&�ڲ�����\��ѵ20130122
% mu1 ����ȡ 20%
% --------------------------------------------
%   Yan Zhang   version 1.0 2013/4/12
% Cheng,Gang;   ver1.1;     20130422; ����������Ĭ��ֵ
%% pre-process

% Ĭ��ֵ
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