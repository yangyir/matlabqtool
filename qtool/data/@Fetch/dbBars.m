function [ bs, sFlag ] = dbBars(code, start_date, end_date, slice_seconds, slice_start, levels)
% 从db取Bars，具体方法是先取Ticks再切Bars，
% 每次只能取一种合约，但切分方式可以有多种
% Code 为证券代码，股票的如 '600000.SH'， 股指的如 'IF1312'(连续合约 'IF0Y00', 'IF0Y01', 'IF0Y02',
% 'IF0Y03', 主力合约 'IFHot')
% start_date为起始时间
% end_date为终止时间
% slice_seconds 表示切片长度，可以是数组如[60,90,120]
% slice_start 表示开始时间，默认是0， 否则要与slice_seconds一一对应

% HeQun 2013.12.23; 初步测试通过，基于IF

%% 预处理
if nargin < 4
    error('取Bar的参数不足！')
elseif nargin < 5
    slice_start = zeros(size(slice_seconds));
else
    if isempty(slice_start)
        slice_start = zeros(size(slice_seconds));
    end
end

sFlag = 0;



%% 建立SQL连接
conn = database('MKTData','TFQuant','2218','com.microsoft.sqlserver.jdbc.SQLServerDriver',...
                ['jdbc:sqlserver://' LocalIP() ':1433;databaseName=MKTData']);
if ~isempty(conn.Message)
    conn.Message
end


bs =Bars;

%% 取证券信息
%当levels未知时取默认参数
if exist('levels', 'var')
    [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date, levels);
else
    [codeArr, dateArr] = genContractInfo(conn, code, start_date, end_date);
end

if isempty(codeArr)
    disp('没有当前代码的行情');
    return;
end


%% 第一天，专门处理
firstDay = 0;
for k = 1:length(codeArr)
    if exist('levels', 'var')
        [ bs, successBars ] = dbDayBars(conn,codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start, levels);
    else
        [ bs, successBars ] = dbDayBars(conn,codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start);
    end
    firstDay = k;
    
    % 如果成功，还原sec code
    if successBars
        if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs(kk).code = code;
            end
        end
        disp(['已经取到',  codeArr{k}, '在' , num2str(dateArr{k}), '的Bar数据！']);
        sFlag = 1;
        break;
    end
end

%% 第2到n天，取出，加入bs
for k = firstDay+1:length(codeArr)
    if exist('levels', 'var')
        [ bs1, successBars ] = dbDayBars(conn, codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start, levels);
    else
        [ bs1, successBars ] = dbDayBars(conn, codeArr{k}, num2str(dateArr{k}), slice_seconds, slice_start);
    end
    
    if successBars
%         对取数据时改动的证券代码进行还原
        disp(['已经取到',  codeArr{k}, '在' , num2str(dateArr{k}), '的Bar数据！']);
        if strcmp(code, 'IFHot') || strcmp(code(1:4), 'IF0Y')
            for kk = 1:length(bs)
                bs1(kk).code = code;
            end
        end
        
%         对于两个bar进行简单的连接
        for kk = 1:length(bs)
            bs(kk).merge( bs1(kk) );
        end
    end
end


%% 关闭SQL连接
close(conn);


end