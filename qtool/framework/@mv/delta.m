function  [outSeq]    = delta(    inSeq, window )
%DELTA 取进入序列的差
% window是向回（历史）位移的长度，若为负值，则向后（将来）位移
% 相减方式是：inSeq - 位移后inSeq
% window 默认1


%% 
if ~exist('window','var'), window = 1; end

%% 
outSeq = nan(size(inSeq));
outSeq(window+1:end) = inSeq(window+1:end) - inSeq(1:end-window);


end

