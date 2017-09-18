clear;
clc;
% conn = database('db','sa','1234','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.41:1433;databaseName=db');


conn = database('test','sa','12345','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.129:1433;databaseName=test');
% sql1 = 'use test select * from table_result'

filename = '@path';
filename2 = '@tempname';


sql1 = 'use test ';
sql1 = [sql1 'declare @fname date,@createtable varchar(50),@tempname varchar(50),@path varchar(1000)'];
sql1 = [sql1 'set @fname=''2011-01-01'''];
sql1 = [sql1 'while(@fname<=''2011-12-31'')'];
sql1 = [sql1 'begin set @tempname=cast(@fname as varchar(50))'];
sql1 = [sql1 'set @path=''E:\test\sz002001_''' filename2 '''.xls'''];
sql1 = [sql1 'declare @result int'];
sql1 = [sql1 'exec master.dbo.xp_fileexist' filename ',@result out'];
sql1 = [sql1 'if @result=0 continue '];
sql1 = [sql1 'else insert into table_result(成交时间,成交价,价格变动,成交量,成交额,性质)'];
sql1 = [sql1 'select * from opendatasource(''Microsoft.Ace.OleDb.12.0'',''Data Source=' filename ';Extended Properties="Excel 12.0;HDR=YES;IMEX=1";'')...[sheet1$] ;'];
sql1 = [sql1 'set @fname=dateadd(day,1,@fname) end'];


cur = exec(conn, sql1);
cur = fetch(cur);
result = cur.data;




