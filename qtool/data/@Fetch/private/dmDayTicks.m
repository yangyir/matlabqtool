function [ ts, Sflag ] = dmDayTicks(secID, req_date, root)
% function [ ts, Sflag ] = dmDayTicks(secID, req_date) ��ȡreq_date��һ���Ticks
% secIDֻ������ȷ���ĺ�Լ������ 'IF1212' �����ĸ�������Լ���� 'IF0Y00' ~ 'IF0Y03'
% req_date ��ʽ�� '20121204'
% driver�ǿ������̷��� Ĭ����'Y'

if nargin < 2
    error('�������㣡')
elseif nargin < 3
    root = 'Y:\qdata\DayTicks\';
end

if exist([root 'IFTable.mat'],'file') == 0
    error('���¼��·��');
end

load([root 'IFTable.mat']);

tickIFName = secID;

% ��������Ƿ����
Sflag  = 0;
reqDateNum  = datenum(req_date, 'yyyymmdd');
if strcmp(secID(1:4), 'IF0Y')
    if ~isempty(find(IFTable(:,1) == reqDateNum,1))
        IFIndex     = str2num(secID(6)); %�������ַ�������������Լ�����
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

    