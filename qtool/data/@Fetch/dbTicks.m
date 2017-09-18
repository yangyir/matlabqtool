function [ tks, sFlag ] = dbTicks(code, start_date, end_date, levels)
% ÿ��ֻ��ȡһ�ֺ�Լ
% Code Ϊ֤ȯ���룬��Ʊ���� '600000.SH'�� ��ָ���� 'IF1312'(������Լ 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', ������Լ 'IFHot')
% start_dateΪ��ʼʱ��
% end_dateΪ��ֹʱ��
% typeΪ֤ȯ����'stock'��ʾ��Ʊ ���� 'future'��ʾ�ڻ�
% levels Ϊ����ĵ���, ���Ʊһ��Ϊ5�����飬 �ڻ�һ��Ϊ1������

% HeQun 2013.12.23
% �̸գ�20131223���Ѻ�������Fetch�࣬����ͨ��
%     ����:����futureû���⣬stockҪ���Ǹ�Ȩ����




%% ��ʼ��
sFlag = 0;

%% ����SQL����
conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
                ['jdbc:sqlserver://' LocalIP() ':1433;databaseName=MKTData']);
if ~isempty(conn.Message)
    conn.Message
end

tks         = Ticks;
firstDay    = 0;

%% 
% ȡIF0Y00��Ӧ�� IF312
if exist('levels','var')
    [dayCode, DayTime] = genContractInfo(conn, code, start_date, end_date, levels);
else
    [dayCode, DayTime] = genContractInfo(conn, code, start_date, end_date);
end
if isempty(dayCode)
    sFlag = 0;
    disp('û�е�ǰ���������');
    return;
end


%% ȡһ���ticks





% ��һ��ѭ����ȡ��һ�������ݵ�ticks����Ϊ�ܽ��
for k = 1:length(dayCode)
    if exist('levels', 'var')
        [ tks, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k}),levels);
    else
        [ tks, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k})); 
    end
    firstDay = k;
    
    
    % ��ɹ�������
    if sFlagD
        if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
            tks.code = code;
        end
        disp(['�Ѿ�ȡ��',  dayCode{k}, '��' , num2str(DayTime{k}), '��Tick���ݣ�']);
        sFlag = 1;
        break;
    end
end

% ȡ�����������ticks�������)���������һ������tks
for k = firstDay+1:length(dayCode)
    if exist('levels', 'var')
        [ ts1, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k}),levels);
    else
        [ ts1, sFlagD ] = dbDayTicks(conn, dayCode{k}, num2str(DayTime{k})); 
    end
    if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
        ts1.code = code;
    end
    
    % ��ɹ�ȡ��������tks
    if sFlagD        
        disp(['�Ѿ�ȡ��',  dayCode{k}, '��' , num2str(DayTime{k}), '��Tick���ݣ�']);
        tks.merge(ts1);
    end
end

%% �ر�SQL����
close(conn);

