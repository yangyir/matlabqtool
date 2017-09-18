function [dailyBars, Sflag] = dbStockDaily(code,startDate,endDate,fuquan,date)
%%
% ����Ϊ�˶�ȡ��Ʊ���� code Ϊ��Ʊ���룬 ���� '600000', ��Ϊ '600000.SH'Ĭ��ȡǰ6λ
% startDate �����ݸ�ʽΪ '20000101' ����ֻ��20000101~20140430������
% ʾ�� [dailyBars, Sflag] = dbStockDaily('000001','20100101','20140701')
% fuquan  1 ��ʾ��ǰ��Ȩ�� 2��ʾ���Ȩ�� 0��ʾ����Ȩ   Ĭ����ǰ��Ȩ
% date ���ø�Ȩʱ��

%��Ⱥ 20140717
if nargin >5
    errer('����̫��')
end

if nargin< 3
    errer('��������')
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

% �����������ݿ⣬û����ʾ��Ϣ��֤�����ӳɹ�
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
    '''��AND CONVERT(int,[date]) >= ' startDate...
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
dailyBars.openInt   = cell2mat(secInfo(:,10));  % ��Դ�ĸ�Ȩ����
dailyBars.preSettlement = cell2mat(secInfo(:,3)); % ���ռ�
Sflag = 1;

if fuquan == 1
    if strcmpi(date, endDate)
        currentFactor = dailyBars.openInt(end);
    else
        sql = ['SELECT [adjustFactor] FROM dbo.dailyMarketFromWind WHERE [contractType] = ''A'' and [contractName] = ''' code...
            '''��AND CONVERT(int,[date]) <= ''' date...
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
            '''��AND CONVERT(int,[date]) <= ''' date...
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
%% �ر�SQL����
close(conn);
end