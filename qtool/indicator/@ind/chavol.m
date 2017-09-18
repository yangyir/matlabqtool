function [ chavolVal ] = chavol( HighPrice, LowPrice, nDay, mDay)
% Chaikin volatility
% default nDay = 10, mDay =10
% daniel 2013/4/16

% ‘§¥¶¿Ì
if ~exist('nDay','var')
    nDay = 10;
end
if ~exist('mDay','var')
    mDay = 10;
end
chavolVal = nan(size(HighPrice));

% º∆À„
for i  = 1: size(HighPrice, 2)
    highp = HighPrice(:,i);
    lowp  = LowPrice(:,i);
    chavolVal(:,i) = chaikvolat(highp, lowp, nDay, mDay);
end
end

