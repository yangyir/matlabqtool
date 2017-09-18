function [dailyBars, Sflag] = dbStockDaily(code,startDate,endDate,fuquan,date)
%%
% 仅仅为了读取股票数据 code 为股票代码， 例如 '600000', 若为 '600000.SH'默认取前6位
% startDate 的数据格式为 '20000101' 现在只有20000101~20140430的数据
% 示例 [dailyBars, Sflag] = dbStockDaily('000001','20100101','20140701')
% fuquan  1 表示向前复权， 2表示向后复权， 0表示不复权   默认向前复权
% date 设置复权时点

%和群 20140717
if nargin >5
    errer('参数太多')
end

if nargin< 3
    errer('参数不足')
end

if nargin == 4
    if fuquan == 1
        date = endDate;
    elseif fuquan == 2
        date = startDate;
    end
end

if nargin == 3
    fuquan = 1;
    date = endDate;
end

% 首先连接数据库，没有显示消息则证明连接成功
conn = database('HistoryData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
    ['jdbc:sqlserver://' LocalIP() ';databaseName=HistoryData']);
if ~isempty(conn.Message)
    conn.Message
    disp(helpForConfing());
end

if length(code) > 6
    code = code(1:6);
end
sql = ['SELECT * FROM dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code...
    '''　AND CONVERT(int,[date]) >= ' startDate...
    'and CONVERT(int,[date]) <= ' endDate ' order by [date]'];
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

dailyBars.code      = code;
dailyBars.time      = cellfun(@(x)datenum(x,'yyyymmdd'), secInfo(:,2));
dailyBars.time2     = cellfun(@(x)x, secInfo(:,2),'UniformOutput', false);
dailyBars.open      = cell2mat(secInfo(:,4));
dailyBars.high      = cell2mat(secInfo(:,5));
dailyBars.low       = cell2mat(secInfo(:,6));
dailyBars.close     = cell2mat(secInfo(:,7));
dailyBars.volume    = cell2mat(secInfo(:,8));
dailyBars.amount    = cell2mat(secInfo(:,9));
dailyBars.openInt   = cell2mat(secInfo(:,10));  % 聚源的复权因子
dailyBars.preSettlement = cell2mat(secInfo(:,3)); % 昨收价
Sflag = 1;

if fuquan == 1
    if strcmpi(date, endDate)
        currentFactor = dailyBars.openInt(end);
    else
        sql = ['SELECT [adjustFactor] FROM dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code...
            '''　AND CONVERT(int,[date]) <= ''' date...
            ''' order by [date]'];
        cur = exec(conn, sql);
        
        if ~isempty(cur.Message)
            cur.Message
        end
        
        cur =  fetch(cur);
        
        if isempty(cur)
            error('error date!');
        end
        
        currentFactor = cur(end);
    end
    dailyBars.open = dailyBars.open/currentFactor.*dailyBars.openInt;
    dailyBars.high = dailyBars.high/currentFactor.*dailyBars.openInt;
    dailyBars.low = dailyBars.low/currentFactor.*dailyBars.openInt;
    dailyBars.close = dailyBars.close/currentFactor.*dailyBars.openInt;
    dailyBars.preSettlement = dailyBars.preSettlement/currentFactor.*dailyBars.openInt;
end

if fuquan == 2
    if strcmpi(date, startDate)
        currentFactor = dailyBars.openInt(1);
    else
        sql = ['SELECT [adjustFactor] FROM dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code...
            '''　AND CONVERT(int,[date]) <= ''' date...
            ''' order by [date]'];
        cur = exec(conn, sql);
        
        if ~isempty(cur.Message)
            cur.Message
        end
        
        cur =  fetch(cur);
        
        if isempty(cur)
            error('error date!');
        end
        
        currentFactor = cur(end);
    end
    dailyBars.open = dailyBars.open*currentFactor./dailyBars.openInt;
    dailyBars.high = dailyBars.high*currentFactor./dailyBars.openInt;
    dailyBars.low = dailyBars.low*currentFactor./dailyBars.openInt;
    dailyBars.close = dailyBars.close*currentFactor./dailyBars.openInt;
    dailyBars.preSettlement = dailyBars.preSettlement*currentFactor./dailyBars.openInt;
end
close(cur);
%% 关闭SQL连接
close(conn);
end