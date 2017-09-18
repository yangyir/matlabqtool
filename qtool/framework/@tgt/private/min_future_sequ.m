function [ outSequ ] = min_future_sequ( inSequ,N )
%% min_future_sequ find smallest in future (or in the next N slices, including current slice)
% outSequ(i) = min(inSequ(i+1:end)), when N is not specified;
% outSequ(i) = min(inSequ(i:i+N-1)), when N is specified;
%%
if nargin == 1
    outSequ = -max_future_sequ(-inSequ);
elseif nargin ==2
    outSequ = -max_future_sequ(-inSequ,N);
end

end