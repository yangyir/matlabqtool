global Path_Gildata;
if isempty(Path_Gildata)
    Path_Gildata = 'D:\MATLAB\R2011b\toolbox\gildata';
end
global Path_Gildata_Backtest;
% 设置路径。以Path_Gildata_Backtest这个变量赋予为起始路径。如果对backtest路径路径进行修改。
% 则只需将维护下面路径即可。将下面路径设为现在backtest文件夹路径即可。
% 例 若backtest路径为： C:\gildata\backtest    则可修改为：
%   Path_Gildata_Backtest =  'C:\gildata\backtest';
Path_Gildata_Backtest = strcat(Path_Gildata,'\Backtest');
path_backtest_configure = strcat(Path_Gildata_Backtest,'\Configure\ConfigureBacktest.xlsx');

% configurefiletype 为1时使用.xlsx作为配置源，2使用.mat作为配置源。
configurefiletype = 1;

% 读取初始设置
disp('正在读入初始设置！请等待！...');
Configure_Gildata_Backtest = readconfigure(path_backtest_configure,configurefiletype);

% 读取策略样例
disp('正在读入策略样例！请等待！...');
Configure_Gildata_Backtest.StrategyExample = readstrategy(Configure_Gildata_Backtest.Path_Strategy_Configure,...
    Configure_Gildata_Backtest.configurefiletype);

Gildata_Backtest_Input2;

