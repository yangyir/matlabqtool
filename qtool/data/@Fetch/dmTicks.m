function [ tks, sFlag ] = dmTicks(code, start_date, end_date, root)
% 每次只能取一种合约
% Code 合约代码如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03')
% start_date为起始时间 '20120104'
% end_date为终止时间 '20120108'
% root 数据存放的路径， 此处应该是开发盘中的数据， 默认是'Y:\qdata\DayTicks\'

% HeQun 2014.1.22

if nargin < 3
    error('参数不足！')
elseif nargin < 4
    root = 'Y:\qdata\DayTicks\';
end



%% 初始化
sFlag = 0;

%% 建立SQL连接

tks         = Ticks;
startDayNum = datenum(start_date, 'yyyymmdd');
endDayNum   = datenum(end_date, 'yyyymmdd');



% 第一次循环，取第一天有数据的ticks，作为总结果
for k = startDayNum:endDayNum
    [ tks, sFlagD ] = dmDayTicks(code, datestr(k,'yyyymmdd'),root);
    firstDay = k;
    
    
    % 如成功，跳出
    if sFlagD
        disp(['已经取到',  code, '在' , datestr(k,'yyyymmdd'), '的Tick数据！']);
        sFlag = 1;
        break;
    end
end

% 取接下来几天的ticks（如存在)，并连入第一天数据tks
for k = firstDay+1:endDayNum
    [ ts1, sFlagD ] = dmDayTicks(code, datestr(k,'yyyymmdd'),root);
    
    % 如成功取出，连入tks
    if sFlagD        
        disp(['已经取到',  code, '在' , datestr(k,'yyyymmdd'), '的Tick数据！']);
        tks.merge(ts1);
    end
end
