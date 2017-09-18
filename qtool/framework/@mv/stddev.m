function [ outSeq] = stddev( inSeq , window )
%STDDEV ����


%%
if ~exist('window', 'var'), window = 10; end

N = length(inSeq);
if N < window
    error('error: window size > seq length!');
end



% %% ������nan�ĸɾ���inSeq, ������index
% inSeq2 = inSeq(~isnan(inSeq));
% idx = find(~isnan(inSeq));
% 
% 
% %% ����ɾ��ġ�inSeq -> outSeq
% N = length(inSeq2);
% 
% %% ��ԭoutSeq�е�nan
% outSeq = nan(size(inSeq));
% outSeq(idx) = outSeq2;



%%
outSeq = nan(size(inSeq));

for i = window + 1: length(inSeq)
    outSeq(i) = nanstd( inSeq(i-window:i) );
end
    


end

