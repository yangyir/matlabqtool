function [minBars, Sflag] = dbStockBars(code,startDate,endDate,sliceMinutes, fuquan,date)
%%
% 仅仅为了读取股票数据 code 为股票代码， 例如 '600000', 若为 '600000.SH'默认取前6位
% startDate 的数据格式为 '20100101' 现在只有20100101~20140430的数据有复权数据，5月1日后的数据无复权
% 示例 [minBars, Sflag] = dbStockBars('000001','20140501','20140701',1, 1)
% sliceMinutes 切片长度，单位分钟
% fuquan  1 表示向前复权， 2表示向后复权， 0表示不复权   默认向前复权
% date 设置复权时点

%和群 20140717

% 参数处理
if nargin >6
    errer('参数太多')
end

if nargin< 3
    errer('参数不足')
end

if nargin == 5
    if fuquan == 1
        date = endDate;
    elseif fuquan == 2
        date = startDate;
    end
end

if nargin == 4
    fuquan = 1;
    date = endDate;
end

if nargin == 3
    sliceMinutes = 1;
    fuquan = 1;
    date = endDate;
end

% 首先连接数据库，没有显示消息则证明连接成功
conn = database('HistoryData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
    ['jdbc:sqlserver://' LocalIP() ':1433;']);
% conn = database('HistoryData','TFQuant','2218') ;%,'com.microsoft.sqlserver.jdbc.SQLServerDriver') ;,...
%['jdbc:sqlserver://' LocalIP() '']);
if ~isempty(conn.Message)
    conn.Message
    disp(helpForConfing());
end

% 处理股票代码，使得其与数据库中的代码相同
if length(code) <=6
    if str2double(code) >=600000
        code = [code '.SH'];
    else
        code = [code '.SZ'];
    end
end

startMonNum = str2double(startDate(1:6));
endMonNum   = str2double(endDate(1:6));

%% 简单处理，重复代码暂时不做优化
% 为确保取数据的，我们按月分开取数据
if startMonNum == endMonNum
    % 同一个月的数据
    sql = ['SELECT * FROM HistoryData.dbo.stock1Min_' startDate(1:6) ' WHERE [code] = ''' code...
        '''　AND CONVERT(int,[tradingDate]) >= ' startDate...
        'and CONVERT(int,[tradingDate]) <= ' endDate ' order by [tradingDate], [time]'];
    [minBars, Sflag] = getTempBars(sql,conn,sliceMinutes);
    
elseif  endMonNum - startMonNum == 1 || endMonNum - startMonNum == 89
    % 相邻两个月的数据
    sql = ['SELECT * FROM HistoryData.dbo.stock1Min_' startDate(1:6) ' WHERE [code] = ''' code...
        '''　AND CONVERT(int,[tradingDate]) >= ' startDate...
        ' order by [tradingDate], [time]'];
    [minBars1, Sflag1] = getTempBars(sql,conn,sliceMinutes);
    sql = ['SELECT * FROM HistoryData.dbo.stock1Min_' endDate(1:6) ' WHERE [code] = ''' code...
        '''and CONVERT(int,[tradingDate]) <= ' endDate ' order by [tradingDate], [time]'];
    [minBars2, Sflag2] = getTempBars(sql,conn,sliceMinutes);
    
    Sflag = 1;
    if Sflag1 == 0 && Sflag2 == 0
        Sflag = 0;
    elseif Sflag1 == 0
        minBars = minBars2;
    elseif Sflag2 == 0
        minBars = minBars1;
    else
        minBars = cartBars(minBars1,minBars2);
    end
else
    % 隔多个月的数据
    sql = ['SELECT * FROM HistoryData.dbo.stock1Min_' startDate(1:6) ' WHERE [code] = ''' code...
        '''　AND CONVERT(int,[tradingDate]) >= ' startDate...
        ' order by [tradingDate], [time]'];
    [minBars, Sflag] = getTempBars(sql,conn,sliceMinutes);
    
    currentMon = startMonNum+1;
    if(mod(currentMon,100)>12)
        currentMon = currentMon+88;
    end
    while currentMon < endMonNum
        sql = ['SELECT * FROM HistoryData.dbo.stock1Min_' num2str(currentMon) ' WHERE [code] = ''' code...
            ''' order by [tradingDate], [time]'];
        [minBarsTemp, SflagTemp] = getTempBars(sql,conn,sliceMinutes);
        minBars = cartBars(minBars,minBarsTemp);
        Sflag = Sflag || SflagTemp;
        currentMon = currentMon +1;
        if(mod(currentMon,100)>12)
            currentMon = currentMon+88;
        end
        sql = ['SELECT * FROM HistoryData.dbo.stock1Min_' endDate(1:6) ' WHERE [code] = ''' code...
            '''and CONVERT(int,[tradingDate]) <= ' endDate ' order by [tradingDate], [time]'];
        [minBarsTemp, SflagTemp] = getTempBars(sql,conn,sliceMinutes);
        minBars = cartBars(minBars,minBarsTemp);
        Sflag = Sflag || SflagTemp;
    end
    
    if Sflag == 0
        return;
    end
end

% 获得复权因子
sql = ['SELECT [date], [adjustFactor] FROM HistoryData.dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code(1:6)...
    '''　AND CONVERT(int,[date]) >= ' startDate...
    'and CONVERT(int,[date]) <= ' endDate ' order by [date]'];
cur = exec(conn, sql);

if ~isempty(cur.Message)
    cur.Message
end

cur =  fetch(cur);
fuquanData = cur.data;

if size(fuquanData,2) < 2
    Sflag = 0;
    disp('No AdjustFactor, the data fetched is origin data!');
    return;
end

fuquanDateNum     = cellfun(@(x)datenum(x,'yyyymmdd'),fuquanData(:,1));
fuquanValue       = cell2mat(fuquanData(:,2));

barTime           = floor(minBars.time);
minBars.openInt   = nan(size(barTime));

for k = 1:length(fuquanDateNum)
    kIndex = find(barTime == fuquanDateNum(k));
    if ~isempty(kIndex)
        minBars.openInt(kIndex) = fuquanValue(k);
    end
end

if fuquan == 1
    if strcmpi(date, endDate)
        currentFactor = minBars.openInt(end);
    else
        sql = ['SELECT [adjustFactor] FROM HistoryData.dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code(1:6)...
            '''　AND CONVERT(int,[date]) <= ''' date...
            ''' order by [date]'];
        cur = exec(conn, sql);
        
        if ~isempty(cur.Message)
            cur.Message
        end
        
        curdata =  fetch(cur);
        curdata = curdata.data;
        if isempty(curdata)
            error('error date!');
        end
        
        currentFactor = curdata{end};
    end
    minBars.open = minBars.open/currentFactor.*minBars.openInt;
    minBars.high = minBars.high/currentFactor.*minBars.openInt;
    minBars.low = minBars.low/currentFactor.*minBars.openInt;
    minBars.close = minBars.close/currentFactor.*minBars.openInt;
    minBars.preSettlement = minBars.preSettlement/currentFactor.*minBars.openInt;
end

if fuquan == 2
    if strcmpi(date, startDate)
        currentFactor = minBars.openInt(1);
    else
        sql = ['SELECT [adjustFactor] FROM HistoryData.dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code(1:6)...
            '''　AND CONVERT(int,[date]) <= ''' date...
            ''' order by [date]'];
        cur = exec(conn, sql);
        
        if ~isempty(cur.Message)
            cur.Message
        end
        
        curdata =  fetch(cur);
        curdata = curdata.data;
        
        if isempty(curdata)
            error('error date!');
        end
        
        currentFactor = curdata{end};
    end
    minBars.open = minBars.open*currentFactor./minBars.openInt;
    minBars.high = minBars.high*currentFactor./minBars.openInt;
    minBars.low = minBars.low*currentFactor./minBars.openInt;
    minBars.close = minBars.close*currentFactor./minBars.openInt;
    minBars.preSettlement = minBars.preSettlement*currentFactor./minBars.openInt;
end
close(cur);
%% 关闭SQL连接
close(conn);
end

function [dailyBars, Sflag] = getTempBars(sql,conn,sliceMinutes)
%% 主要是按月读取数据库中的数据，并将数据存放在bars中
cur = exec(conn, sql);

if ~isempty(cur.Message)
    cur.Message
end

cur =  fetch(cur);
dailyBars = Bars;
if size(cur.data,2) < 2
    %     disp([secID,' ',req_date,' ',end_date,' has no data in database']);
    Sflag = 0;
    return;
else
    secInfo = cur.data;
end

dailyBars.code      = secInfo(1,2);
timestr             = cellfun(@(x,y)strcat(x,y), secInfo(:,1),secInfo(:,3),'UniformOutput',false);
dailyBars.time      = cellfun(@(x)datenum(x,'yyyymmddHHMM'), timestr);
dailyBars.time2     = cell2mat(timestr);
dailyBars.open      = cell2mat(secInfo(:,5));
dailyBars.high      = cell2mat(secInfo(:,6));
dailyBars.low       = cell2mat(secInfo(:,7));
dailyBars.close     = cell2mat(secInfo(:,8));
dailyBars.volume    = cell2mat(secInfo(:,9));
dailyBars.amount    = cell2mat(secInfo(:,10));
dailyBars.preSettlement = cell2mat(secInfo(:,4)); % 昨收价

% 当所需要的数据不是一分钟数据，还需要做特殊处理
% 我查询了数据库中的数据，发现数据基本上没有遗漏，所以直接按照分钟Bar的个数数的所有的数据
if sliceMinutes > 1
    timeSeg = 0:sliceMinutes:240;
    if timeSeg(end) ~= 240
        timeSeg(end+1) = 240;
    end
    
    firstAfterBar = find(timeSeg>120,1,'first');
    timeSeg(firstAfterBar:end) = timeSeg(firstAfterBar:end) + 90;
    timeSeg    = timeSeg + 570;
    timeSeg = floor(timeSeg/60)*100 + mod(timeSeg,60);
    
    barDay = str2double(secInfo(:,1));
    bar1Num = length(barDay);
    uniBarDay = unique(barDay);
    sliceNum = length(uniBarDay)*ceil(240/sliceMinutes);
    slice = Bars;
    slice.code      = secInfo(1,2);
    slice.time      = nan(sliceNum,1);
    slice.time2     = nan(sliceNum,1);
    slice.open      = nan(sliceNum,1);
    slice.high      = nan(sliceNum,1);
    slice.low       = nan(sliceNum,1);
    slice.close     = nan(sliceNum,1);
    slice.volume    = nan(sliceNum,1);
    slice.amount    = nan(sliceNum,1);
    slice.preSettlement = nan(sliceNum,1); % 昨收价
    barTime         = str2double(secInfo(:,3));
    currentBar1Index    = 1;
    currentBarIndex    = 1;
    while currentBar1Index < bar1Num
        if barTime(currentBar1Index) == 930
            try
                if(isempty(find(timeSeg == barTime(currentBar1Index+sliceMinutes),1,'first')))
                    error('Data missing!');
                end
            catch e
                break;
            end
            currentBar1Index = currentBar1Index+sliceMinutes;
            slice.time(currentBarIndex)      = dailyBars.time(currentBar1Index);
            slice.time2(currentBarIndex)     = dailyBars.time2(currentBar1Index);
            slice.open(currentBarIndex)      = dailyBars.open(currentBar1Index-sliceMinutes);
            slice.high(currentBarIndex)      = max(dailyBars.high(currentBar1Index-sliceMinutes:currentBar1Index));
            slice.low(currentBarIndex)       = min(dailyBars.low(currentBar1Index-sliceMinutes:currentBar1Index));
            slice.close(currentBarIndex)     = dailyBars.close(currentBar1Index);
            slice.volume(currentBarIndex)    = sum(dailyBars.volume(currentBar1Index-sliceMinutes:currentBar1Index));
            slice.amount(currentBarIndex)    = sum(dailyBars.amount(currentBar1Index-sliceMinutes:currentBar1Index));
            slice.preSettlement(currentBarIndex) = dailyBars.preSettlement(currentBar1Index);
            currentBarIndex = currentBarIndex + 1;
            currentBar1Index = currentBar1Index + 1;
        else
            try
                
                if(isempty(find(timeSeg == barTime(currentBar1Index+sliceMinutes-1),1,'first')))
                    if(isempty(find(barTime(currentBar1Index:currentBar1Index+sliceMinutes-1)==1500,1,'first')))
                        error('Data missing!');
                    else
                        lastBarNo   = find(barTime(currentBar1Index:currentBar1Index+sliceMinutes-1)==1500,1,'first') + currentBar1Index -1;
                    end
                else
                    lastBarNo   = currentBar1Index+sliceMinutes-1;
                end
            catch e
                lastBarNo = bar1Num;
            end
            slice.time(currentBarIndex)      = dailyBars.time(lastBarNo);
            slice.time2(currentBarIndex)     = dailyBars.time2(lastBarNo);
            slice.open(currentBarIndex)      = dailyBars.open(currentBar1Index);
            slice.high(currentBarIndex)      = max(dailyBars.high(currentBar1Index:lastBarNo));
            slice.low(currentBarIndex)       = min(dailyBars.low(currentBar1Index:lastBarNo));
            slice.close(currentBarIndex)     = dailyBars.close(lastBarNo);
            slice.volume(currentBarIndex)    = sum(dailyBars.volume(currentBar1Index:lastBarNo));
            slice.amount(currentBarIndex)    = sum(dailyBars.amount(currentBar1Index:lastBarNo));
            slice.preSettlement(currentBarIndex) = dailyBars.preSettlement(lastBarNo);
            currentBarIndex     = currentBarIndex + 1;
            currentBar1Index    = lastBarNo + 1;
        end
    end
    dailyBars = slice;
end
Sflag = 1;
end

function bs1 = cartBars(bs1,bs2)
% 做两个Bar的连接，将bs2添加到bs1后面
bs1.time      = [bs1.time;bs2.time];
bs1.time2     = [bs1.time2;bs2.time2];
bs1.open      = [bs1.open;bs2.open];
bs1.high      = [bs1.high;bs2.high];
bs1.low       = [bs1.low;bs2.low];
bs1.close     = [bs1.close;bs2.close];
bs1.volume    = [bs1.volume;bs2.volume];
bs1.amount    = [bs1.amount;bs2.amount];
bs1.openInt   = [bs1.openInt;bs2.openInt];
bs1.preSettlement = [bs1.preSettlement;bs2.preSettlement]; % 昨收价
end