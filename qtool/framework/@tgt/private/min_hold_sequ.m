function [ outSequ ] = min_hold_sequ( inSequ, N )
%% min_hold_sequ find the smallest in the past (or in the last N slices, including current slice)
% outSequ(i) = min(inSequ(1:i)), when N is not specified;
% outSequ(i) = min(inSequ(i-N+1:i)), when N is specified;
%%
if nargin == 1
    outSequ = -max_hold_sequ(-inSequ);
elseif nargin ==2
    outSequ = -max_hold_sequ(-inSequ,N);
end


end

