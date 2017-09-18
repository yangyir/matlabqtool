clear;
clc;
bars = importdata('bars.mat');
candle60s = cdl(0.06);
candle60s.label_pattern(bars,candle60s.isEngulfingDown(bars));

