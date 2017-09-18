clear;
clc;
bars = importdata('data.mat');
len = length(bars.time);
% plot(bars.vwap,'b');
% hold on;
% big= max_past_sequ(bars.vwap,100);
% small = min_past_sequ(bars.vwap,100);
% plot(big, 'r');
% hold on
% plot(small, 'g');

plotyy(1:len,maxRealizedDown(bars.vwap,200,'c'),1:len,bars.vwap);