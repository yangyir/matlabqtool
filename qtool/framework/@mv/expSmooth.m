function [ outSeq ] = expSmooth( inSeq, alpha)
%EXPSMOOTHAVG 指数平滑 exponential smoothing moving average
% S_t=aY_t+(1-a)S_t-1
%   Y_t: inSeq
%   S_t: outSeq, smoothed sequence
% 程刚；20140913；加强了对inSeq中nan的耐受性
% 

%%
if ~exist('alpha', 'var')
    alpha = 0.5;
    warning('warning @mv.expSmooth: using default alpha=0.5 in exp smoothing');
end

if alpha<0 || alpha>1
    error('error @mv.expSmooth: alpha out of [0,1], using default alpha =0.5');
    alpha = 0.5;
end

%% 挑出非nan的干净的inSeq, 并留下index
inSeq2 = inSeq(~isnan(inSeq));
idx = find(~isnan(inSeq));


%% 计算干净的　inSeq -> outSeq
N = length(inSeq2);
outSeq2 = nan(N,1);

outSeq2(1) = inSeq2(1);

for i = 2:N
    outSeq2(i) = alpha * inSeq2(i) + (1-alpha) * outSeq2(i-1);
end


%% 还原outSeq中的nan
outSeq = nan(size(inSeq));
outSeq(idx) = outSeq2;

end

