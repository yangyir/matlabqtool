function [ outSeq ] = max_hold_sequ( inSeq, N )
%% max_hold_sequ find the largest in the past (or in the last N slices, including current slice)
% outSeq(i) = max(inSeq(1:i)), when N is not specified;
% outSeq(i) = max(inSeq(i-N+1:i)), when N is specified;
%%
len = length(inSeq);
outSeq = inSeq;

if nargin == 1
    for i = 2:len
        if inSeq(i)>outSeq(i-1)
            outSeq(i) = inSeq(i);
        else
            outSeq(i) = outSeq(i-1);
        end
    end
elseif nargin ==2
    for i = N:len
        outSeq(i) = max(inSeq(i-N+1:i));
    end
    for i = 1:N-1
        outSeq(i) = max(inSeq(1:i));
    end    
end

end

