function [ hit ] = HitRetio( price, buy, sell, sellshort, buycover )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nPeriod = length(price);
if length(buy) ~= length(sell) 
    sell = [sell; nPeriod];
end
if length(sellshort) ~= length(buycover)
    buycover = [buycover; nPeriod];
end
pos = price(sell) - price(buy);
neg = price(sellshort) - price(buycover);
hit = (sum(pos > 0) + sum(neg > 0))/(length(buy) + length(sellshort));
    
end

