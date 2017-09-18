function [ ts, Sflag ] = dmDayTicks(secID, req_date, root)
% function [ ts, Sflag ] = dmDayTicks(secID, req_date) 获取req_date这一天的Ticks
% secID只允许是确定的合约代码如 'IF1212' 或者四个连续合约代码 'IF0Y00' ~ 'IF0Y03'
% req_date 格式如 '20121204'
% driver是开发盘盘符， 默认是'Y'

if nargin < 2
    error('参数不足！')
elseif nargin < 3
    root = 'Y:\qdata\DayTicks\';
end

if exist([root 'IFTable.mat'],'file') == 0
    error('重新检查路径');
end

load([root 'IFTable.mat']);

tickIFName = secID;

% 检查行情是否存在
Sflag  = 0;
reqDateNum  = datenum(req_date, 'yyyymmdd');
if strcmp(secID(1:4), 'IF0Y')
    if ~isempty(find(IFTable(:,1) == reqDateNum,1))
        IFIndex     = str2num(secID(6)); %第六个字符代表了连续合约的序号
        IFNameNum   = IFTable(IFTable(:,1) == reqDateNum,3+IFIndex);
        if(IFNameNum~= 0)
            dataNumStr = ['IF' num2str(IFNameNum) req_date '.mat'];
            Sflag      = 1;
        end
    end
elseif strcmp(secID, 'IFHot')
    if ~isempty(find(IFTable(:,1) == reqDateNum,1))
        IFNameNum   = IFTable(IFTable(:,1) == reqDateNum,7);
        if(IFNameNum~= 0)
            dataNumStr = ['IF' num2str(IFNameNum) req_date '.mat'];
            Sflag      = 1;
        end
    end
else
    contactList = contactList(contactList(:,2) == reqDateNum,:);
    if ~isempty(contactList)
        if ~isempty(find(contactList(:,1) == str2num(secID(3:6)),1))
            dataNumStr = [secID(1:6) req_date '.mat'];
            Sflag      = 1;
        end
    end
end

if Sflag
    load([root dataNumStr]);
    ts = tks;
    ts.code = tickIFName;
else
    ts = Ticks;
    ts.code = tickIFName;
end

    