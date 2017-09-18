function [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date, levels)
% ÿ��ֻ��ȡһ�ֺ�Լ
% Code Ϊ֤ȯ���룬��Ʊ���� '600000.SH'�� ��ָ���� 'IF1312'(������Լ 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', ������Լ 'IFHot')
% start_dateΪ��ʼʱ��
% end_dateΪ��ֹʱ��

% Hequn, 20131224;


%% �������ݿ�
% conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
%     'jdbc:sqlserver://10.41.7.61:1433;databaseName=MKTData');
% if ~isempty(conn.Message)
%     conn.Message
% end
% 

%% 
startDtNum  = datenum(start_date,'yyyymmdd');
endDtNum    = datenum(end_date,'yyyymmdd');

%�ж���ȡ�����levels�� û�иñ������վ�Դ�����ݽ������
if ~exist('levels', 'var') || levels ==1   
    if strcmp(code, 'IFHot')
        %% ��ͬ��IFHot���ڴ˴���
        
        % SELECT [Date], MainContract FROM dbo.ContractIndex WHERE
        % [Date] >= 20131201 AND [Date] <= 20131205 AND IsTradingDay = 1
        
        
        sql = ['SELECT [Date], MainContract FROM dbo.ContractIndex WHERE [Date] >= ' ...
            start_date ' AND [Date] <= ' end_date ' AND IsTradingDay = 1'];
%         cur = exec(conn, sql);
        cur.data =  fetch(conn, sql,50000);
        if size(cur.data,2) ~= 1
            codeArr = cur.data(:,2);
            dateArr = cur.data(:,1);
        else
            codeArr ={};
            dateArr ={};
        end
%         close(cur);
    elseif strcmp(code(1:4), 'IF0Y')
        %% ��ͬ��IF0Y00���ڴ˴���
        
        % SELECT [Date], IF0Y00 FROM dbo.ContractIndex WHERE
        %        [Date] >= 20131201 AND [Date] <= 20131205 AND IsTradingDay = 1
        sql = ['SELECT [Date], ' code ' FROM dbo.ContractIndex WHERE [Date] >= ' ...
            start_date ' AND [Date] <= ' end_date ' AND IsTradingDay = 1'];
%         cur = exec(conn, sql);
        cur.data =  fetch(conn, sql,50000);
        if size(cur.data,2) ~= 1
            codeArr = cur.data(:,2);
            dateArr = cur.data(:,1);
        else
            codeArr ={};
            dateArr ={};
        end
%         close(cur);
        
        
    else
        %% ��ͬ��IF1312���ڴ˴���
        % TODO�������⣬û���㽻����
        % ѡ��ϵͳ���������������������¼
        %SELECT [Date], SecID FROM dbo.TableImformation WHERE
        %[Date] >= 20131201 AND [Date] <= 20131205 AND SecID = 'IF1312'
        sql = ['SELECT [Date], SecID FROM dbo.TableImformation WHERE [Date] >= ' ...
            start_date ' AND [Date] <= ' end_date ' AND SecID = ''' code(1:6) ''' AND Levels = 1'];
%         cur = exec(conn, sql);
        cur.data =  fetch(conn, sql,50000);
        if size(cur.data,2) ~= 1
            codeArr = cur.data(:,2);
            dateArr = cur.data(:,1);
        else
            codeArr ={};
            dateArr ={};
        end
%         close(cur);
        
        %     if startDtNum > endDtNum
        %         codeArr ={};
        %         dateArr ={};
        %     else
        %         dtNum      = transpose(startDtNum:endDtNum);
        %         dtNumStr   = str2num(datestr(dtNum,'yyyymmdd'));
        %         codeArr     = repmat({code},endDtNum-startDtNum+1,1);
        %         dateArr     = mat2cell(dtNumStr,ones(endDtNum-startDtNum+1,1),1);
        %     end
    end
elseif levels == 10
    if strcmp(code, 'IFHot')
        sql = ['SELECT [Date], IFHot FROM dbo.FiveLevels WHERE [Date] >= ' ...
            start_date ' AND [Date] <= ' end_date];
%         cur = exec(conn, sql);
        cur.data =  fetch(conn, sql,50000);
        if size(cur.data,2) ~= 1
            codeArr = cur.data(:,2);
            dateArr = cur.data(:,1);
        else
            codeArr ={};
            dateArr ={};
        end
%         close(cur);
    end
else
    error('��ʱû�и�����');
end
%% �Ͽ����ݿ�
% close(conn);