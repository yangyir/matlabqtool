function [ outSequ ] = max_future_sequ( inSequ,  N)
%% max_future_sequ find largest in future (or in the next N slices, including current slice)
% outSequ(i) = max(inSequ(i+1:end)), when N is not specified;
% outSequ(i) = max(inSequ(i:i+N-1)), when N is specified;
%%
len = length(inSequ);
outSequ = inSequ;

if nargin == 1
    for i = 1:len-1
        if inSequ(end-i)>outSequ(end-i+1)
            outSequ(end-i) = inSequ(end-i);
        else
            outSequ(end-i) = outSequ(end-i+1);
        end
    end
elseif nargin ==2
    for i = 1:len-N+1
        outSequ(i) = max(inSequ(i:i+N-1));
    end
    for i = len-N+2:len
        outSequ(i) = max(inSequ(i:end));
    end    
end

end

