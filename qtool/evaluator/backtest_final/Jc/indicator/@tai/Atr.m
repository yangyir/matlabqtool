function [atr] = Atr( high, low, close, nDay)
% average true range signal 未定义！！
%ATR is based on the True Range, which uses absolute price changes. As
%such, ATR reflects volatility as absolute level. In other words, ATR is
%not shown as a percentage of the current close. This means low priced
%stocks will have lower ATR values than high price stocks. For example, a
%$20-30 security will have much lower ATR values than a $200-300 security.
%Because of this, ATR values are not comparable. Even large price movements
%for a single security, such as a decline from 70 to 20, can make long-term
%ATR comparisons impractical. Chart 4 shows Google with double digit ATR
%values and chart 5 shows Microsoft with ATR values below 1. Despite
%different values, their ATR lines have similar shapes ATR is not a
%directional indicator, such as MACD or RSI. Instead, ATR is a unique
%volatility indicator that reflects the degree of interest or disinterest
%in a move. Strong moves, in either direction, are often accompanied by
%large ranges, or large True Ranges. This is especially true at the
%beginning of a move. Uninspiring moves can be accompanied by relatively
%narrow ranges. As such, ATR can be used to validate the enthusiasm behind
%a move or breakout. A bullish reversal with an increase in ATR would show
%strong buying pressure and reinforce the reversal. A bearish support break
%with an increase in ATR would show strong selling pressure and reinforce
%the support break.

% daniel 2013/4/3

if isempty(nDay)
    nDay = 20;
end
if ~exist('type', 'var') || isempty(type), type = 1; end
%% 计算步
[nPeriod, nAsset] = size(high);
atr=ind.atr(high,low,close,nDay);






