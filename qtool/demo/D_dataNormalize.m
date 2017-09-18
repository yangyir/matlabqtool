%%
% dataNormalize 使股指期货隔夜时间序列连续
% start_date输入形式cell，默认为{'IF0Y00_20120104.mat'};
% nDate 自start_date开始，提取nDate天的数据
% path 默认路径为Y:\qdata\IF\intraday_bars_60s_daily\
%% input
clc
clear
close all
% load('Y:\qdata\IF\intraday_bars_60s_daily\IF0Y00_20130104.mat');
% load('Y:\qdata\IF\intraday_bars_60s_daily\IF0Y00_20130107.mat');
% priceTrain = IF0Y00_20130104.close;
% price = IF0Y00_20130107.close;
slice_seconds = 60;
start_date = {'IF0Y00_20120104.mat'};
nDate = 10;
path = ['Y:\qdata\IF\intraday_bars_' num2str(slice_seconds) 's_daily\'];
priceTrain = db.dataNormalize( start_date,nDate,slice_seconds,path );

start_date = {'IF0Y00_20120502.mat'};
price = db.dataNormalize(start_date);