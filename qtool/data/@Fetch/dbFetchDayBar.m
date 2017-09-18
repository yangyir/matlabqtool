function [ bs, Sflag ] = dbFetchDayBar(secID, req_date, slice_seconds, slice_start, levels, type)
%% 该函数至少有三个参数
% 切片类型为前闭后开 [0,60)
% secID 为证券代码 '600000.SZ'或者 'IF1312.CFE' 前六个代码不能错
%req_date行情的日期 '20131219
% slice_seconds 切片的时间间隔(s) 60表示一分钟
% slice_start 表示第一个切片结束的时间(s) 20表示前20s为一个切片，以后每slice_seconds一个切片
% levels 切片的档数 通常股票为5 期货为1
% type为证券类型'stock'表示股票 或者 'future'表示期货

%HeQun 2013.12.23
if nargin < 3
    error('切片的参数不足！')
elseif nargin < 4
    slice_start = zeros(size(slice_seconds));    
end

if length(slice_seconds) ~= length(slice_start)
    error('切片的长度向量和开始时间向量长度不等！');
end

bs          = Bars;
if exist('type','var') == 0
    if exist('levels','var') == 0
        [ ts, SflagT ] = dbFetchDayTick(secID, req_date);
    else
        [ ts, SflagT ] = dbFetchDayTick(secID, req_date, levels);
    end
else
    [ ts, SflagT ] = dbFetchDayTick(secID, req_date, levels, type);
end

if SflagT
    if length(slice_seconds) >1
        for k =1:length(slice_seconds)
            bs(k) = Tick2Bar(ts, slice_seconds(k), slice_start(k));
        end
    else
        bs = Tick2Bar(ts, slice_seconds, slice_start);
    end
    Sflag =1;
else
    Sflag = 0;
end
end

