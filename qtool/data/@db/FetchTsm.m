function TSMobj = FetchTsm(  params, conn )
%FetchFromDB Fetch a TsMatrix from DB under params conditions
% conn        the connection to DB
% params      contains related params such timespan, assets, etc.
% ret         returns a TsMatrix 


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


%% following codes could saparate as a standalone function 1weizhuan2wei



%% fetch dates
dates = result(:,1);

[dts, ia, ic1 ] = unique(dates);
dts = cell2mat(dts);
% dts = datenum(dts);

% '20100104' -> 734872, as is needed in TsMatrix
dots = nan( size(dts,1), 1);
dots(:,1) = '.';  dots = char(dots);

dts = [dts(:,1:4) dots dts(:,5:6) dots dts(:,7:8)];
dts = datenum(dts, 'yyyy.mm.dd');


%% fetch assets
assets = result(:,2);
[as, ia, ic2] = unique(assets);

mat_data = nan( size(dts,1), size(as,1) );



%% fetch data
data =cell2mat(result(:,3));


%% fill in TsMatrix
TSMobj = TsMatrix;

% special play with pctchange
if strcmp( params.property, 'pctchange')
    TSMobj.datatype = 'pct';
    data = data./100;
end


% ic2 indicates assets
ic2unique = unique(ic2);

% playing with indices is very very confusing!
for i = 1:ic2unique(end)
    idx = find(ic2 == i);
    mat_data(ic1(idx),i) = data(idx);
end
    

TSMobj.dates = dts;
TSMobj.assets = as';
TSMobj.data = mat_data;
TSMobj.AutoFill();
TSMobj.des = sql;


end

