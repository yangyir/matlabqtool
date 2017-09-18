function [ llVal ] = ll( LowPrice, nDay )
% Lowest of Low
% default nDay = 20
% daniel 2013/4/16

if ~exist('nDay', 'var'), nDay = 20; end
llVal = nan(size(LowPrice));

for i = 1: size(LowPrice, 2)
    llVal(:,i) = llow(LowPrice(:,i), nDay);
end

end