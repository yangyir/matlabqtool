function [ sig_long, sig_short, cle ] = Cle(bar, mu_up, mu_down)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if ~exist('mu_up', 'var'), mu_up = 0.05; end
if ~exist('mu_down', 'var'), mu_down = 0.05;end

close = bar.close;

nAsset = size(close, 2);
sig_long = zeros(size(close));
sig_short = zeros(size(close));
priceHigh = nan(size(close));
priceLow  = nan(size(close));

for i= 1: nAsset
    [priceHigh(:,i), priceLow(:,i)] = LastExtrema(close(:,i), mu_up, mu_down);
end
sig_long(logical(crossOver(close, priceHigh))) = 1;
sig_short(logical(crossOver(priceLow, close))) = -1;

cle.lasthigh = priceHigh;
cle.lastlow = priceLow;

if nargout == 0
    bar.plotind2(sig_long + sig_short, cle);
    title('sig long and short');
end
end

