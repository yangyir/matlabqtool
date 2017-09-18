function [ tks, sFlag ] = dbTicks(code, start_date, end_date, levels)
% 每次只能取一种合约
% Code 为证券代码，股票的如 '600000.SH'， 股指的如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', 主力合约 'IFHot')
% start_date为起始时间
% end_date为终止时间
% type为证券类型'stock'表示股票 或者 'future'表示期货
% levels 为行情的档数, 如股票一般为5档行情， 期货一般为1档行情

% HeQun 2013.12.23
% 程刚，20131223；把函数加入Fetch类，测试通过
%     隐患:对于future没问题，stock要考虑复权问题




%% 初始化
sFlag = 0;

%% 建立SQL连接
conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
                ['jdbc:sqlserver://' LocalIP() ':1433;databaseName=MKTData']);
if ~isempty(conn.Message)
    conn.Message
end

tks         = Ticks;
firstDay    = 0;

%% 
% 取IF0Y00对应的 IF312
if exist('levels','var')
    [dayCode, DayTime] = genContractInfo(conn, code, start_date, end_date, levels);
else
    [dayCode, DayTime] = genContractInfo(conn, code, start_date, end_date);
end
if isempty(dayCode)
    sFlag = 0;
    disp('没有当前代码的行情');
    return;
end


%% 取一天的ticks





% 第一次循环，取第一天有数据的ticks，作为总结果
for k = 1:length(dayCode)
    if exist('levels', 'var')
        [ tks, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k}),levels);
    else
        [ tks, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k})); 
    end
    firstDay = k;
    
    
    % 如成功，跳出
    if sFlagD
        if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
            tks.code = code;
        end
        disp(['已经取到',  dayCode{k}, '在' , num2str(DayTime{k}), '的Tick数据！']);
        sFlag = 1;
        break;
    end
end

% 取接下来几天的ticks（如存在)，并连入第一天数据tks
for k = firstDay+1:length(dayCode)
    if exist('levels', 'var')
        [ ts1, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k}),levels);
    else
        [ ts1, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k})); 
    end
    if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
        ts1.code = code;
    end
    
    % 如成功取出，连入tks
    if sFlagD        
        disp(['已经取到',  dayCode{k}, '在' , num2str(DayTime{k}), '的Tick数据！']);
        tks.merge(ts1);
    end
end

%% 关闭SQL连接
close(conn);

