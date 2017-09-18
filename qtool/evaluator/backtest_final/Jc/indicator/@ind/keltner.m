function [ upband, lowband ] = keltner( HighPrice, LowPrice, ClosePrice , maDay,atrDay,  multiplier)
% Keltner Channels
% default maDay = 20, atrDay = 20, multiplier = 2.5;
% daniel 2013/4/18

if ~exist('maDay','var'), maDay = 20;end
if ~exist('atrDay', 'var'), atrDay = 20; end
if ~exist('multiplier', 'var'), multiplier = 2.5; end

% º∆À„≤Ω
% Keltner Channels (Original), using Keltner's first published settings: a
% 10-day simple moving average of Typical Price and 10-day average daily
% range (high - low) with a multiple of 1; and Keltner Channels, the more
% popular version from Linda Raschke: a 20-day exponential moving average
% of Closing Price and a multiple of 2.5 times 20-day Average True Range.

upband = ind.ma(ClosePrice, maDay, 'e') + multiplier * ind.atr(HighPrice, LowPrice, ClosePrice, atrDay);
lowband = ind.ma(ClosePrice, maDay, 'e') - multiplier * ind.atr(HighPrice, LowPrice, ClosePrice, atrDay);

end

