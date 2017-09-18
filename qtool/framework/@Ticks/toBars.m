function [bs] = toBars(obj, slice_seconds, slice_start)
% TOBARS 使用的是一天的Tick数据转换为Bar
% [bs] = toBars(obj, slice_seconds, slice_start)

% ts 表示Tick数据
% bs 表示Bar数据

%HeQun 2013.12.23

%% 
% if exist('obj','class')
%     error('Tick 数据有误，无法转化为Bar！');
% end

bs          = Bars;
if isempty(obj.time)
    return;
end

%% 时间数据中含有nan数据当作有错误数据处理
if any(isnan(obj.time))
    error('Tick 数据中有Nan数据，无法转化为Bar！');
end

% 通过第一个时间判定当天的时间
Timevec             = datevec(obj.time(1));

%% 判断证券类型， 生成时间节点
if strcmp(obj.type, 'stock')
    % 股票每天有240分钟交易时间，共有240*60=14400s交易时间，
    % 按照入参进行划分, timeSeg表示
    timeSeg     =   transpose(slice_start:slice_seconds:14400);
    
    
    %　最后一个Bar的处理，若timeSeg最后一个数据不是交易结束时间，
    %  将交易结束时间作为Bars的最后时间
    if timeSeg(end) < 14400
        timeSeg(end+1) = 14400;
    end
    
    
    %　第一个Bar的处理，　若开始时间不是０，将[0,slice_start]作为一天的第一个Bar
    if slice_start >0
        timeSeg = [0;timeSeg];
    end
    
    % 加上中午休息的时间
    timeSeg(timeSeg>7200)  = timeSeg(timeSeg>7200)+5400;
    
    % 将时间用Matlab小数表示后再加上当天的时间， 主要目的是用来和time做比较
    timeSeg = timeSeg/86400 + datenum([Timevec(1:3),9,30,0]);
elseif strcmp(obj.type, 'future')
    % 股票每天有270分钟交易时间，共有270*60=16200s交易时间，
    % 按照入参进行划分
    timeSeg = transpose(slice_start:slice_seconds:16200);
    if timeSeg(end) < 16200
        timeSeg(end+1) = 16200;
    end
    %　若开始时间不是０，将[0,slice_start]作为一天的第一个Bar
    if slice_start >0
        timeSeg = [0;timeSeg];
    end
    
    % 加上中午休息的时间，8100ｓ对应2h15min,5400s对应1h30min
    timeSeg(timeSeg>8100)   = timeSeg(timeSeg>8100)+5400;
    
    % 将时间用Matlab小数表示后再加上当天的时间， 用来和time做比较
    timeSeg = timeSeg/86400 + datenum([Timevec(1:3),9,15,0]);
elseif strcmp(obj.type, 'Gfuture')
    % 商品期货每天有240分钟交易时间，共有240*60=14400s交易时间，
    % 按照入参进行划分
    timeSeg = transpose(slice_start:slice_seconds:14400);
    if timeSeg(end) < 14400
        timeSeg(end+1) = 14400;
    end
    %　若开始时间不是０，将[0,slice_start]作为一天的第一个Bar
    if slice_start >0
        timeSeg = [0;timeSeg];
    end
    
    % 加上中午休息的时间，9000ｓ对应2h30min,7200s对应2h0min
    timeSeg(timeSeg>9000)   = timeSeg(timeSeg>9000)+7200;
    
    % 将时间用Matlab小数表示后再加上当天的时间， 用来和time做比较
    timeSeg = timeSeg/86400 + datenum([Timevec(1:3),9,00,0]);
else
    error('不可识别的证券类型，证券类型应该是''stock''或者 ''future''');
end

%% 填充一些标量以及初始化
slicetype   = int32(slice_seconds*100000+slice_start*10);

bs.time      = timeSeg(2:end);
bs.code      = obj.code;
bs.type      = obj.type;
bs.slicetype = slicetype;
bs.time2 = str2num(datestr(bs.time,'HHMMSS'));

startIndex = 1;
barNum = length(timeSeg)-1;
bs.open      = nan(barNum,1);
bs.high      = nan(barNum,1);
bs.low       = nan(barNum,1);
bs.close     = nan(barNum,1);
bs.amount    = nan(barNum,1);    %元
bs.volume    = nan(barNum,1);    %股
bs.tickNum   = nan(barNum,1);
if strcmp(obj.type, 'future')
    bs.openInt   = nan(barNum,1);
end

%% 逐一填充每个Bar的数值
for k = 1:barNum
    % 查找k个bar的结束位置在tick中的序号
    endIndex = find(obj.time > timeSeg(k+1),1,'first') - 1;
    
    if isempty(endIndex)
        endIndex = length(obj.time);
    end
    % 当有数据在Bar里面时进行bar的填充
    if(~(isempty(endIndex) || endIndex < startIndex))
        bs.open(k)      = obj.last(startIndex);
        bs.high(k)      = max(obj.last(startIndex:endIndex));
        bs.low(k)       = min(obj.last(startIndex:endIndex));
        bs.close(k)     = obj.last(endIndex);
        bs.amount(k)    = obj.amount(endIndex) - obj.amount(startIndex);    %元
        bs.volume(k)    = obj.volume(endIndex) - obj.volume(startIndex);    %股
        bs.tickNum(k)   = endIndex - startIndex + 1;
        if strcmp(obj.type, 'future')
            bs.openInt(k)   = obj.openInt(endIndex);
        end
        startIndex      = endIndex + 1;
    end    
end

% 填充对应的标量
bs.settlement       = obj.close; % ！！！有问题！！！
bs.preSettlement    = obj.preSettlement;
% bs.tickNum          = endIndex - startIndex + 1;
bs.date             = str2num(datestr(bs.time(1),'yyyymmdd'));
end
