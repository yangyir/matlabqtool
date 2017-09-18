function writetradingdatetool()

tradingdate = DQ_GetDate_V('000001.SHI','1990-01-01',datestr(today,29));
global Path_Gildata
path =strcat(Path_Gildata,'\Backtest\Cache\tradingdate.mat');
save(path,'tradingdate');

end