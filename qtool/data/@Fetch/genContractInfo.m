function [DayCode, DayTime] = genContractInfo(Code, start_date, end_date)
% 每次只能取一种合约
% Code 为证券代码，股票的如 '600000.SH'， 股指的如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', 主力合约 'IFHot')
% start_date为起始时间
% end_date为终止时间

conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
    'jdbc:sqlserver://10.41.7.61:1433;databaseName=MKTData');
if ~isempty(conn.Message)
    conn.Message
end

startDayNum = datenum(start_date,'yyyymmdd');
endDayNum = datenum(end_date,'yyyymmdd');

if strcmp(Code, 'IFHot')
    sql = ['SELECT [Date], MainContract FROM dbo.ContractIndex WHERE [Date] >= ' start_date ' AND [Date] <= ' end_date ' AND IsTradingDay = 1'];
    cur = exec(conn, sql);
    cur =  fetch(cur);
    if size(cur.data,2) ~= 1
        DayCode = cur.data(:,2);
        DayTime = cur.data(:,1);
    else
        DayCode ={};
        DayTime ={};
    end
    close(cur);
elseif strcmp(Code(1:4), 'IF0Y')
    sql = ['SELECT [Date], ' Code ' FROM dbo.ContractIndex WHERE [Date] >= ' start_date ' AND [Date] <= ' end_date ' AND IsTradingDay = 1'];
    cur = exec(conn, sql);
    cur =  fetch(cur);
    if size(cur.data,2) ~= 1
        DayCode = cur.data(:,2);
        DayTime = cur.data(:,1);
    else
        DayCode ={};
        DayTime ={};
    end
    close(cur);
else
    if startDayNum > endDayNum
        DayCode ={};
        DayTime ={};
    else
        DayNum = transpose(startDayNum:endDayNum);
        DayNumStr = str2num(datestr(DayNum,'yyyymmdd'));
        DayCode = repmat({Code},endDayNum-startDayNum,1);
        DayTime = mat2cell(DayNumStr,ones(endDayNum-startDayNum+1,1),1);
    end
end
close(conn);