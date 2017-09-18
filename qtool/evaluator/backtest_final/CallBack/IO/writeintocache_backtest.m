%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������������ָ��֤ȯ���루������á�������������Ӧָ����ʼ�ͽ�ֹ����֮�����
% �������ݣ����浽backtest Cache�У��ļ���Ϊ֤ȯ���롣
% ��������������ݸ�ʽ���£�
% 732686	4.460868254	4.48874868	4.419047614	4.453898147	11022101	6.39	215.9386515
% 732687	4.426017721	4.432987827	4.286615588	4.377226974	21426743	6.28	212.2213977
% 732688	4.377226974	4.426017721	4.321466121	4.342376441	9749282     6.23	210.5317369
% 732689	4.328436228	4.377226974	4.314496014	4.377226974	6720529     6.28	212.2213977
% 732690	4.356316654	4.426017721	4.307525908	4.328436228	7996673     6.21	209.8558726
% ����       ǰ��Ȩ����   ǰ��Ȩ���   ǰ��Ȩ���   ǰ��Ȩ����   �ɽ���   ����Ȩ����  ��Ȩ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function writeintocache_backtest(SecuCode,StartDate,EndDate,Path_backtest)

% ����Cahce�ļ���
% mkdir(Path_backtest);


SecuCode = cellstr(SecuCode);
% ����Ϊ��Ȼ��
Dates = datestr(datenum(StartDate)-1:datenum(EndDate),29);
NumDates = datenum(Dates);
% ��Cache��������ȣ�Ѱ��ȱʧ���ڣ�����ȱʧ��������
for Index = 1:length(SecuCode)
    path_dq = strcat(Path_backtest,SecuCode{Index},'.dat');
    if exist(path_dq,'file')
        
        originaldata = dlmread(path_dq);
        Date = originaldata(:,1);
        missingdates = datestr(checkmissingdate(NumDates,Date),29);
        if (isempty(missingdates))
            continue;
        else
            output = download('DQ',SecuCode{Index},missingdates);
            
            
            DQ =sortrows([originaldata;output],1);
            
            if ~isempty(DQ)
                dlmwrite(path_dq,DQ,'delimiter','\t','precision',16);
            end
        end
    else
        DQ = download('DQ',SecuCode{Index},Dates);
        if ~isempty(DQ)
            dlmwrite(path_dq,DQ ,'delimiter','\t','precision',16);
        end
    end
end

%  ����ָ��֤ȯ��ָ�����ڵ���������߸�Ƶ����
    function  output = download(data_type,SecuCode,Day)
        output = zeros(size(Day,1),8);
        switch data_type
            case 'DQ'
                open_3 = DQ_QueryDailyData_V(SecuCode,Day,'Open',3);
                high_3 = DQ_QueryDailyData_V(SecuCode,Day,'High',3);
                low_3 = DQ_QueryDailyData_V(SecuCode,Day,'Low',3);
                close_3 = DQ_QueryDailyData_V(SecuCode,Day,'Close',3);
                volume = DQ_QueryDailyData_V(SecuCode,Day,'Volume',3);
                close_1 = DQ_QueryDailyData_V(SecuCode,Day,'Close',1);
                close_2 = DQ_QueryDailyData_V(SecuCode,Day,'Close',2);
                output = [datenum(Day),open_3',high_3',low_3',close_3',volume',close_1',close_2'];
            case 'HF'
            otherwise
        end  
    end
%  ����ȱʧ����
    function missingdates = checkmissingdate(DateNew,DateOld)
        DateNewCell = num2cell(DateNew);
        indexDateOld = cellfun(@(x) ~(ismember(x,DateOld)),DateNewCell);
        missingdates = DateNew(indexDateOld==1);
    end
end



