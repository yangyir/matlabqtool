function [ hhVal ] = hh( HighPrice, nDay )
% highest of high 
% default nDay =20;
% daniel 2013/4/16

if ~exist('nDay', 'var'), nDay = 20; end
hhVal = nan(size(HighPrice));

for i = 1: size(HighPrice, 2)
    hhVal(:,i) = hhigh(HighPrice(:,i), nDay);
end
end

