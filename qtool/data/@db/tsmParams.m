function paramTSM = tsmParams(property, assets, startdate, enddate, tablename,dbname)
%TSMPARAMS returns a struct with input fields and a sql script
% property            should be a single property              
% assets              cells of asset codes
% startdate           
% enddate             default = '30000101'  
% dbname              default = 'db'
% tablename           default = 'asharedayprices'


%% default values & input check
sql_use = [];
if nargin >=6    
    sql_use = [' use ' dbname];
    paramTSM.dbname = dbname;
end

if nargin < 6
%     dbname = 'db';
    if nargin< 5 
        tablename =  'asharedayprices';
        if nargin < 4
            enddate = '30000101';
        end
    end
end




%% sql_use_select_from
paramTSM.tablename = tablename;
paramTSM.property = property;

sql_select =  [' select [trade_date],[stock_code],[', property,'] '];    
sql_from = [' from ' tablename ];



%% sql_where_assets
if iscell(assets)
    paramTSM.assets = assets;
    sql_where_assets = [];
    for  i = 1:length(assets)
        sql_where_assets = [sql_where_assets,'''',assets{i},''','];
    end
    sql_where_assets = sql_where_assets(1:end-1);
end
sql_where_assets = [ ' stock_code in (', sql_where_assets, ') '];



%% sql_where_dates
paramTSM.startdate = startdate;
if isempty(enddate) enddate = '30000101'; end
paramTSM.enddate = enddate;

sql_where_dates = [ ' trade_date>= ''' startdate ''' '];
sql_where_dates = [sql_where_dates, ' and trade_date <= ''',enddate, ''' '];


%% sql_where
sqlwhere = [' where ' sql_where_assets ' and ' sql_where_dates];


%% final sql query
paramTSM.sql = [sql_use, sql_select, sql_from, sqlwhere];



end

