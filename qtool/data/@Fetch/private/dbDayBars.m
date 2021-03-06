function [ bs, success ] = dbDayBars(conn, secID, reqDate, sliceSeconds, sliceStart, levels, type)
%% 从db中抓Ticks，再切成Bars 
% 该函数至少有三个参数
% 切片类型为前闭后开 [0,60)
% secID 为证券代码 '600000.SZ'或者 'IF1312.CFE' 前六个代码不能错，　不能是'IFHot"等特殊合约
%req_date行情的日期 '20131219
% slice_seconds 切片的时间间隔(s) 60表示一分钟
% slice_start 表示第一个切片结束的时间(s) 20表示前20s为一个切片，以后每slice_seconds一个切片
% levels 切片的档数 通常股票为5 期货为1
% type为证券类型'stock'表示股票 或者 'future'表示期货

%HeQun 2013.12.23

%% 预处理
if nargin < 4
    error('切片的参数不足！')
elseif nargin < 5
    sliceStart = zeros(size(sliceSeconds));    
end

% 判断切片的时间段个数是否与切片的起始时间个数相同
if length(sliceSeconds) ~= length(sliceStart)
    error('切片的长度向量和开始时间向量长度不等！');
end

% success  = 0; % 预处理， 默认一开始切片还没有切成功

%% 抓Ticks， 由于数据库中的数据量有限， 暂时对于type和levels不作处理
bs          = Bars;
if ~exist('type','var')
    if ~exist('levels','var')
        [ ts, successTicks ]    = dbDayTicks(conn, secID, reqDate);
    else
        [ ts, successTicks ]    = dbDayTicks(conn, secID, reqDate, levels);
    end
else
    [ ts, successTicks ]        = dbDayTicks(conn, secID, reqDate, levels, type);
end


%% 切成Bars
if successTicks
    if length(sliceSeconds) >1
%         对于多个切片的数据循环切割
        for k =1:length(sliceSeconds)
            bs(k) = ts.toBars(sliceSeconds(k), sliceStart(k));
        end
    else
%         只有一个切片的切割
        bs  = ts.toBars(sliceSeconds, sliceStart);
    end
    success =1;
else
    success = 0;
end
end

