%%
% dataNormalize ʹ��ָ�ڻ���ҹʱ����������
% start_date������ʽcell��Ĭ��Ϊ{'IF0Y00_20120104.mat'};
% nDate ��start_date��ʼ����ȡnDate�������
% path Ĭ��·��ΪY:\qdata\IF\intraday_bars_60s_daily\
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