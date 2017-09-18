function [ ts, Sflag ] = dbDayTicks(conn, secID, req_date, levels, type)
%% �ú�����������������
% secID Ϊ֤ȯ���� '600000.SZ'���� 'IF1312.CFE' ǰ�������벻�ܴ�
% typeΪ֤ȯ����'stock'��ʾ��Ʊ ���� 'future'��ʾ�ڻ�
% levels Ϊ����ĵ���, ���Ʊһ��Ϊ5������
% req_date���������

%HeQun 2013.12.23
% �̸գ�20131223�����ע�͡�
%     ���ݹ����д�ȱ�ݣ���ǰIFֻ��level1����ֻ����һ��

%% Ԥ����
if nargin <3
    error('Tick��ȡ�������㣡')
end

%% �������ݿ�
% conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
%     'jdbc:sqlserver://10.41.7.61:1433;databaseName=MKTData');
% if ~isempty(conn.Message)
%     conn.Message
% end


%% ��֤���ݿ����Ƿ�������
sql = ['SELECT TOP 10 * FROM dbo.TableImformation WHERE SecID = ''' secID(1:6)...
    '''��AND [Date] = ' req_date];

ts = Ticks;
cur = exec(conn, sql);
cur =  fetch(cur);
if size(cur.data,2) < 2
%     disp([secID,' ',req_date,' ',end_date,' has no data in database']);
    Sflag = 0;
    return;
else
    secInfo = cur.data;
end

%% ��������
% ��δ���type
if exist('type','var') == 0
    if strcmp(secInfo(1,4),'1')
        type = '1';
        ts.type = 'stock';
    elseif strcmp(secInfo(1,4),'2')
        type = '2';
        ts.type = 'future';
    else
        error('δ֪֤ȯ����');
    end
end

% ��δ���: levels
if exist('levels','var') == 0
    if strcmp(secInfo(1,4),'1')
        levels = 5;
        ts.levels = levels;
    elseif strcmp(secInfo(1,4),'2')
        levels = 1;
        ts.levels = levels;
    else
        error('δ֪֤ȯ����');
    end
end

ts.code = [secInfo{1,1}(1:6),'.',secInfo{1,3}];
ts.latest = 0;

%% ȡ֤ȯ�ĵ�����Ϣ

% SELECT * FROM dbo.TableImformation WHERE SecID = 'IF1312'��AND [Date] = 20131202 AND Levels =1
sql = ['SELECT * FROM dbo.TableImformation WHERE SecID = ''' secID(1:6)...
    '''��AND [Date] = ' req_date ' AND Levels =' num2str(levels)];

cur = exec(conn, sql);
cur =  fetch(cur);
if size(cur.data,2) < 2
%     disp([secID,' ',req_date,' ',end_date,' has no data in database']);
    Sflag = 0;
    return;
else
    secInfo = cur.data;
end

% ����Ticks�ı�����
ts.dt               = cell2mat(secInfo(:,2));
ts.open             = cell2mat(secInfo(:,7));
ts.high             = cell2mat(secInfo(:,10));
ts.low              = cell2mat(secInfo(:,11));
ts.close            = cell2mat(secInfo(:,8));
ts.dayVolume        = cell2mat(secInfo(:,12));
ts.dayAmount        = cell2mat(secInfo(:,13));
ts.preSettlement    = cell2mat(secInfo(:,9));

%% ȡ֤ȯ���ڵ���ϸTICK����        
reqDay = datenum(req_date,'yyyymmdd');

codeFName = secInfo{1,6};
% select * from IF1312CFE  where [Time] >= 735570 and [Time] < 735571 order by [Time]
sql_select =  ['select * from ',codeFName, ' where [Time] >= ',num2str(reqDay),' and [Time] < ',num2str(reqDay+1), ' order by [Time]'];
cur = exec(conn, sql_select);
cur = fetch(cur);
assetList = cur.data;
if size(assetList,2)<2
    Sflag = 0;
    return;
end

% ��������
tickData = cell2mat(assetList);

ts.time     = tickData(:,2);
ts.time2    = datestr(tickData(:,2),'HHMMSS');
ts.last     = tickData(:,3);
if strcmp(type , '2')
    ts.openInt  = tickData(:,4);
    ts.volume   = tickData(:,5);
    ts.amount   = tickData(:,6);
    ts.bidP     = tickData(:,7);
    ts.bidV     = tickData(:,8);
    ts.askP     = tickData(:,9);
    ts.askV     = tickData(:,10);
else
    ts.volume   = tickData(:,4);
    ts.amount   = tickData(:,5);
    ts.bidP     = tickData(:,[6,8,10,12,14]);
    ts.bidV     = tickData(:,[7,9,11,13,15]);
    ts.askP     = tickData(:,[16,18,20,22,24]);
    ts.askV     = tickData(:,[17,19,21,23,25]);
end

close(cur);

% % �ر�SQL����
% close(conn);


Sflag = 1;
end