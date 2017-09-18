function assetList = FetchAssetList( index_name, index_time,conn, table_name )
%FETCHASSET ͨ����ѯ����ȡ��Ʊ����
% conn �������ݿ���
% table_name ����
% index_name ������ָ��
% index_time ������ʱ��
% Cheng,Gang; 2013


%% default values
if nargin <4
    table_name = '[as].aindexmembers_temp';
    if nargin < 3
        conn = database('db','sa','1234','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://NO5:1433;databaseName=db');
        if nargin <2
            index_time = datestr(now-1,'yyyymmdd');%���û����ʱ�������ȡ��ǰʱ���ǰһ��
        end
    end
end

%% sql


sql_select1 =  ['select distinct([stock_code]) from ',table_name, ' where index_name = ','''',index_name,'''','and cur_sign = 1',' and indate<','''',index_time,''''];    
sql_union = [' union all '];
sql_select2 =  ['select distinct([stock_code]) from ',table_name, ' where index_name = ','''',index_name,'''',' and indate<','''',index_time,'''',' and outdate>','''',index_time,''''];  

sql = [sql_select1,sql_union,sql_select2];

cur = exec(conn, sql);
cur = fetch(cur);
assetList = cur.data;

end