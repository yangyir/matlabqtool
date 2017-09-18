function [ outSeq ] = min_past_sequ( inSeq, N )
%% min_past_sequ find the smallest in the past (or in the last N slices, including current slice)
% outSequ(i) = min(inSequ(1:i)), when N is not specified;
% outSequ(i) = min(inSequ(i-N+1:i)), when N is specified;
% -------------------------------------------------------
% ver1.0;     Pan,Qichao;     20130418;
% ver1.1;     Cheng,Gang;     20130418; 改进算法，提高效率

%% pre-process
if ~exist('N','var')    N = 1; end

%% main
len     = length(inSeq);
outSeq  = ones(len,1) * inSeq(N);
preMin  = inSeq(N);

for i = N:len
    preMin      = min(preMin, inSeq(i) );
    outSeq(i)   = preMin;
end    




end

