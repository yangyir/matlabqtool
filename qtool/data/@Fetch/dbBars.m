function [ bs, sFlag ] = dbBars(code, start_date, end_date, slice_seconds, slice_start, levels)
% ��dbȡBars�����巽������ȡTicks����Bars��
% ÿ��ֻ��ȡһ�ֺ�Լ�����зַ�ʽ�����ж���
% Code Ϊ֤ȯ���룬��Ʊ���� '600000.SH'�� ��ָ���� 'IF1312'(������Լ 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', ������Լ 'IFHot')
% start_dateΪ��ʼʱ��
% end_dateΪ��ֹʱ��
% slice_seconds ��ʾ��Ƭ���ȣ�������������[60,90,120]
% slice_start ��ʾ��ʼʱ�䣬Ĭ����0�� ����Ҫ��slice_secondsһһ��Ӧ

% HeQun 2013.12.23; ��������ͨ��������IF

%% Ԥ����
if nargin < 4
    error('ȡBar�Ĳ������㣡')
elseif nargin < 5
    slice_start = zeros(size(slice_seconds));
else
    if isempty(slice_start)
        slice_start = zeros(size(slice_seconds));
    end
end

sFlag = 0;



%% ����SQL����
conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
                ['jdbc:sqlserver://' LocalIP() ':1433;databaseName=MKTData']);
if ~isempty(conn.Message)
    conn.Message
end


bs =Bars;

%% ȡ֤ȯ��Ϣ
%��levelsδ֪ʱȡĬ�ϲ���
if exist('levels', 'var')
    [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date, levels);
else
    [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date);
end

if isempty(codeArr)
    disp('û�е�ǰ���������');
    return;
end


%% ��һ�죬ר�Ŵ���
firstDay = 0;
for k = 1:length(codeArr)
    if exist('levels', 'var')
        [ bs, successBars ] = dbDayBars(conn,codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start, levels);
    else
        [ bs, successBars ] = dbDayBars(conn,codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start);
    end
    firstDay = k;
    
    % ����ɹ�����ԭsec code
    if successBars
        if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs(kk).code = code;
            end
        end
        disp(['�Ѿ�ȡ��',  codeArr{k}, '��' , num2str(dateArr{k}), '��Bar���ݣ�']);
        sFlag = 1;
        break;
    end
end

%% ��2��n�죬ȡ��������bs
for k = firstDay+1:length(codeArr)
    if exist('levels', 'var')
        [ bs1, successBars ] = dbDayBars(conn, codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start, levels);
    else
        [ bs1, successBars ] = dbDayBars(conn, codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start);
    end
    
    if successBars
%         ��ȡ����ʱ�Ķ���֤ȯ������л�ԭ
        disp(['�Ѿ�ȡ��',  codeArr{k}, '��' , num2str(dateArr{k}), '��Bar���ݣ�']);
        if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs1(kk).code = code;
            end
        end
        
%         ��������bar���м򵥵�����
        for kk = 1:length(bs)
            bs(kk).merge( bs1(kk) );
        end
    end
end


%% �ر�SQL����
close(conn);


end