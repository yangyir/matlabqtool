clear;
clc;
%% Fetch share codes at designated category and time.
% 
%%
conn = database('db','sa','1234','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.41:1433;databaseName=db');
index_time = '20130401';
% use name not code here.
index_name = '石油石化(中信)';
assets = db.FetchAssetList(index_name,index_time,conn);
