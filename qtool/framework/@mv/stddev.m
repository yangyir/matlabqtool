function [ outSeq] = stddev( inSeq , window )
%STDDEV 方差


%%
if ~exist('window', 'var'), window = 10; end

N = length(inSeq);
if N < window
    error('error: window size > seq length!');
end



% %% 挑出非nan的干净的inSeq, 并留下index
% inSeq2 = inSeq(~isnan(inSeq));
% idx = find(~isnan(inSeq));
% 
% 
% %% 计算干净的　inSeq -> outSeq
% N = length(inSeq2);
% 
% %% 还原outSeq中的nan
% outSeq = nan(size(inSeq));
% outSeq(idx) = outSeq2;



%%
outSeq = nan(size(inSeq));

for i = window + 1: length(inSeq)
    outSeq(i) = nanstd( inSeq(i-window:i) );
end
    


end

