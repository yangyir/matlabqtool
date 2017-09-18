function [ price ] = dataNormalize( start_date,nDate,slice_seconds,path )
% dataNormalize 使股指期货隔夜时间序列连续
% start_date输入形式cell，默认为{'IF0Y00_20120104.mat'};
% nDate 自start_date开始，提取nDate天的数据
% path 默认路径为Y:\qdata\IF\intraday_bars_60s_daily\
%% 默认值和验参

if ~iscell(start_date)
    error('start_date is not cell')
end

if ~exist('slice_seconds','var')
    slice_seconds = 60;
end

if ~exist('start_date','var')
    start_date = {'IF0Y00_20120104.mat'};
end

if ~exist('nDate','var');
    nDate = 10;
end

if ~exist('path','var');
    path = ['Y:\qdata\IF\intraday_bars_' num2str(slice_seconds) 's_daily\'];
end


%% main
filename = cellstr( ls(path) );
ismatch = strcmp( start_date,filename );
positionStart =  find(ismatch==1 ) ;
price = [];
for i = 0:nDate-1
    if i == 0
        todayName = filename{positionStart+i};
        data = load([ path todayName]);
        priceToday = eval( ['data.',todayName(1:end-4),'.close'] );
        priceYesterday = priceToday;
    else
        todayName = filename{positionStart+i};
        data = load([ path todayName]);
        priceToday = eval( ['data.',todayName(1:end-4),'.close'] ); 
        priceYesterday = priceToday - ( priceToday(1)-priceYesterday(end) );
    end
    price = [price; priceYesterday];
end

end

