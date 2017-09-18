clear;
clc;
%% Fetch market quotation.
conn = database('db','sa','1234','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.41:1433;databaseName=db');


% conn = database('test','sa','12345','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.129:1433;databaseName=test');
% sql1 = 'use test select * from table_result'

% sql1 = 'use test ';
% sql1 = [sql1 ' insert into table_result(成交时间,成交价,价格变动,成交量,成交额,性质) '];
% sql1 = [sql1 ' select * '];
% sql1 = [sql1 ' from opendatasource(''Microsoft.Ace.OleDb.12.0'',''Data Source="e:/test/sz002001_2011-01-04.xls";Extended Properties="Excel 12.0;HDR=YES;IMEX=1";'')...[sheet1$] ;'];
% 
% 
% cur = exec(conn, sql1);
% cur = fetch(cur);
% result = cur.data;


% assets = {'000001.sz','600223.SH'};

% % 关键：指数名一定要精确地和表中一致
% index_name = '沪深300';
% index_time = '20120309';
% assets = db.FetchAssetList(index_name,index_time,conn);
% 
sdt = '19910101';
edt = '20130409';
% property = 'close';
% db1 = 'db';
% table1 = '[as].[asharedayprices]';
% 
% 
% %% fetch a TsMatrix from DB
% 
% 
% par  = db.tsmParams( property,assets, sdt, edt,table1,db1);
% 
% closeprice = db.FetchTsm( par, conn );
% 
% %% fetch a SingleAsset
properties = {'close','open','high','low','volume'};
asset = '000001.sh';
table2 = '[as].[aindexdayprices]'; %取指数行情 

par = db.saParams( properties,asset, sdt, edt,table2);

PingAnYinHang = db.FetchSa( par, conn ) ;














