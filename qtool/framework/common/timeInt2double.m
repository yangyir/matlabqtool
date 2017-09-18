function [ t ] = timeInt2double( raw )
%TIMEINT2NUM Summary of this function goes here
%   Detailed explanation goes here

% ≈À∆‰≥¨£¨20140508£¨V1.0

fff = mod(raw,10);
raw = floor(raw/10);

ss = mod(raw,100);
raw = floor(raw/100);

mm = mod(raw,100);
hh = floor(raw/100);

t = ((hh*3600+mm*60+ss)*1000+fff*500)/86400000;
end

