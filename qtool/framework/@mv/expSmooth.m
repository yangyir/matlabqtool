function [ outSeq ] = expSmooth( inSeq, alpha)
%EXPSMOOTHAVG ָ��ƽ�� exponential smoothing moving average
% S_t=aY_t+(1-a)S_t-1
%   Y_t: inSeq
%   S_t: outSeq, smoothed sequence
% �̸գ�20140913����ǿ�˶�inSeq��nan��������
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

%% ������nan�ĸɾ���inSeq, ������index
inSeq2 = inSeq(~isnan(inSeq));
idx = find(~isnan(inSeq));


%% ����ɾ��ġ�inSeq -> outSeq
N = length(inSeq2);
outSeq2 = nan(N,1);

outSeq2(1) = inSeq2(1);

for i = 2:N
    outSeq2(i) = alpha * inSeq2(i) + (1-alpha) * outSeq2(i-1);
end


%% ��ԭoutSeq�е�nan
outSeq = nan(size(inSeq));
outSeq(idx) = outSeq2;

end

