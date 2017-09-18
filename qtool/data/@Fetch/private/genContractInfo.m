function [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date, levels)
% 每次只能取一种合约
% Code 为证券代码，股票的如 '600000.SH'， 股指的如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', 主力合约 'IFHot')
% start_date为起始时间
% end_date为终止时间

% Hequn, 20131224;


%% 连接数据库
% conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
%     'jdbc:sqlserver://10.41.7.61:1433;databaseName=MKTData');
% if ~isempty(conn.Message)
%     conn.Message
% end
% 

%% 
startDtNum  = datenum(start_date,'yyyymmdd');
endDtNum    = datenum(end_date,'yyyymmdd');

%判断所取行情的levels， 没有该变量则按照聚源的数据进行输出
if ~exist('levels', 'var') || levels ==1   
    if strcmp(code, 'IFHot')
        %% 形同‘IFHot’在此处理
        
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
        %% 形同‘IF0Y00’在此处理
        
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
        %% 形同‘IF1312’在此处理
        % TODO：有问题，没有算交易日
        % 选出系统中所有满足条件的行情记录
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
    error('暂时没有该行情');
end
%% 断开数据库
% close(conn);