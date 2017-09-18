%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于读取Path路径下配置文件中的初始配置。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output  = readconfigure(path_backtest_configure,type)
% 若输出参数少于2个，则默认读取excel配置
if nargin <2
    type = 1;
end
global Path_Gildata_Backtest;
if exist(path_backtest_configure,'file') && type == 1
    % 读取布局设置
    [~,~,configure_data] = xlsread(path_backtest_configure,'Layout');
    % 图像界面在屏幕中位置
    output.Figure_Position  = [str2double(configure_data{1,2}),str2double(configure_data{2,2}),str2double(configure_data{3,2}),str2double(configure_data{4,2})];

    %  读取风险指标设置
    [~,~,configure_data] = xlsread(path_backtest_configure,'RiskIndex');
    
    % 业绩基准
    output.benchmark = configure_data{1,2};
    % 市场基准
    output.marketbench = configure_data{2,2};
    % 无风险利率基准
    output.riskfreebench = configure_data{3,2};
    % VaR的置信因子a
    output.vara = configure_data{4,2};
    % 计算VaR所使用的方法（目前只添加方差协方差法）
    output.varmethod = configure_data{5,2};
  
    
    % 读取其它配置
    % [~,~,configure_data] = xlsread(path_backtest_configure,'Input');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'Main');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'Equity');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'BuySellPoint');
    % [~,~,configure_data] = xlsread(path_backtest_configure,'StatisticalIndex');
else
    path_backtest_configure = strrep(path_backtest_configure,'.xlsx','.mat');
    load(path_backtest_configure); 
    output.Figure_Position =Figure_Position;
    output.benchmark = benchmark;
    output.marketbench = marketbench ;
    output.riskfreebench = riskfreebench;
    output.vara = vara;
    output.varmethod = varmethod;
end
% downloadmark 为0，采用实时下载方式下载数据；downloadmark为1时，采用读Cache方式，脱机展现模式。
output.downloadmark = 0;

output.path_backtest_configure = path_backtest_configure;
% Cache路径
output.Path_Backtest_Cache = strcat(Path_Gildata_Backtest,'\Cache\');
% 策略搜索路径
output.Path_Search_Strategy = strcat(Path_Gildata_Backtest,'\Strategy\');
% 策略样例路径
output.Path_Strategy_Configure = strcat(Path_Gildata_Backtest,'\Configure\strategy.xlsx');

output.configurefiletype = type;
% 输出report默认路径
output.outfile = 'C:\reports.xlsx report1';

end
