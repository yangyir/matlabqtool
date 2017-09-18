

clear;
clc;
% conn = database('db','sa','1234','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.41.7.41:1433;databaseName=db');

assets = {'000001.sz','600223.SH'};
sdt = '20100101';
edt = '20110101';
property = 'close';
db1 = 'db';
table = 'asharedayprices';


%% fetch a TsMatrix from DB
par  = mongo.tsmParams( property,assets, sdt, edt,table,db1);

closeprice = mongo.FetchTsm( conn, par );

%% fetch a SingleAsset
% properties = {'close','open','adjclose'};
% asset = '000001.sz';
% 
% par = db.saParams( properties,asset, sdt, edt,table);
% 
% PingAnYinHang = db.FetchSa( conn, par) ;
% 













