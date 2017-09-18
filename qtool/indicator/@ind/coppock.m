function [ copVal ] = coppock( ClosePrice , short, long, nDay)
% Coppock Indicator
% default short = 11; long =14; nDay = 10;

if ~exist('short', 'var'), short = 11; end
if ~exist('long' , 'var'), long  = 14; end
if ~exist('nDay' , 'var'), nDay  = 10; end

% º∆À„≤Ω
% 1. 14 month Rate of Change( price )
% 2. 11 month Rate of Change( price )
% 3 = 1+2
% 4 = weighted moving average of 3

copVal = ind.ma(ind.roc(ClosePrice,short)+ind.roc(ClosePrice,long), nDay, 1);

end

