function paramSA = saParams(properties, asset, startdate, enddate, tablename,dbname  )
%TSMPARAMS ���ô�dbȡtsm�Ĳ���
% dbname�������������� database name
% tablename           table name
% properties            what to query, such as close,high,low,precolse...
% asset              cells of asset codes
% startdate           for example:'20100101'
% enddate             if not given, enddate will be '30000101'
% ��SQL Server��ȡ���ݣ����ʲ�������
% ������
% ��ѯ������[���ݿ��������������ԣ��ʲ�����ʼʱ�䣬����ʱ��]
% ret���ظ�����������ѯ���





%% sql_use
sql_use=[];

if nargin >=6    
    sql_use = [' use ' dbname];
    paramSA.dbname = dbname;
end



%% default values & input check


if nargin < 6
%     dbname = 'db';
    if nargin< 5 
        tablename =  'asharedayprices';
        if nargin < 4
            enddate = '30000101';
        end
    end
end









%% sql_select properties from
paramSA.tablename = tablename;
sql_select =  [' select [trade_date],[stock_code],']; 

if iscell(properties)
    paramSA.properties = properties;
    sql_properties = [];
    for  i = 1:length(properties)
        sql_properties = [sql_properties,'[',properties{i},']',','];
    end
    sql_properties = sql_properties(1:end-1);
end
sql_from = [' from ' tablename ];

%% sql_where_asset
paramSA.asset = asset;
sql_where_asset = [' where stock_code= ','''', asset, ''''];


%% sql_where_dates
paramSA.startdate = startdate;
if isempty(enddate) enddate = '30000101'; end
paramSA.enddate = enddate;

sql_where_dates = [ ' trade_date>= ''' startdate ''' '];
sql_where_dates = [sql_where_dates, ' and trade_date <= ''',enddate, ''' '];


%% sql_where
sql_where = [sql_where_asset ' and ' sql_where_dates];


%% final sql query
paramSA.sql = [sql_use, sql_select,sql_properties, sql_from, sql_where];

end

