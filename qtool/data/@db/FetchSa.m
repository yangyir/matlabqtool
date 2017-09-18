function SAobj = FetchSa( params,conn  )
%FetchFromDB Fetch a TsMatrix from DB under params conditions
% conn        the connection to DB
% params      contains related params such timespan, assets, etc.
% ret         returns a TsMatrix 
% 从SQL Server中取数据，单资产多属性
% 参数：
% conn连接数据库的句柄
% params查询参数，[数据库名，表名，属性，资产，开始时间，结束时间]
% ret返回SingleAsset矩阵


%% default value 
if nargin <2 
    conn = database('db','sa','1234','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.41:1433;databaseName=db');
end


%% SQL Fetch
sql =  params.sql;
cur = exec(conn, sql);
cur = fetch(cur);
result = cur.data;


%% fill empty cell with 'NAN'
result(cellfun('isempty',result)) = {'nan'};


%% fetch dates
dates = result(:,1);
[dts, ia, ic1 ] = unique(dates);
dts = cell2mat(dts);

% '20100104' -> 734872, as is needed in TsMatrix
dots = nan( size(dts,1), 1);
dots(:,1) = '.';  dots = char(dots);

dts = [dts(:,1:4) dots dts(:,5:6) dots dts(:,7:8)];
dts = datenum(dts, 'yyyy.mm.dd');



%% fill in TsMatrix
SAobj =  SingleAsset;

%% fetch data, dates, assets
nPro = size(result,2);
data =cell2mat(result(:,3:nPro));

SAobj.assetcode = params.asset;
SAobj.des = sql;
SAobj.tstypes = params.properties;
SAobj.dates = dts;
SAobj.data = data;
SAobj.AutoFill();



end

