function [ outSequ ] = max_sequence( inSequ )
%% outSequ(i) = max(inSequ(1:i));
%%
len = length(inSequ);
outSequ = inSequ;
for i = 2:len
    outSequ(i) = max(inSequ(i),outSequ(i-1));
end

end

