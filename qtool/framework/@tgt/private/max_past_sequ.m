function [ outSeq ] = max_past_sequ( inSeq, N )
%% max_past_sequ find the largest in the past (or in the last N slices, including current slice)
% outSeq(i) = max(inSeq(1:i)), when N is not specified;
% outSeq(i) = max(inSeq(i-N+1:i)), when N is specified;
% ----------------------------------------------------------
% ver1.0;     Pan, Qichao;    20130418
% ver1.1;     Cheng,Gang;     20130418; 改进算法，提高效率

%% pre-process
if ~exist('N','var')    N = 1; end

%% main
len     = length(inSeq);
% outSeq  = nan(len,1);
outSeq  = ones(len,1) * inSeq(N);
preMax  = inSeq(N);

for i = N:len
    preMax      = max(preMax, inSeq(i) );
    outSeq(i)   = preMax;
end    


end

