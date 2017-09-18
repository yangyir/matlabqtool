%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于生成菜单栏
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handle = top_menu()

%　table file
file = uimenu('Label','文件');
file1 = uimenu(file,'Label','策略输入输出样例','callback','file_examplestrategy_callback();');
file2 = uimenu(file,'Label','单个导入策略','callback',['Configure_Gildata_Backtest.StrategyExample = file_importsinglestrategy_callback(Configure_Gildata_Backtest.StrategyExample,Configure_Gildata_Backtest.Path_Strategy_Configure,Configure_Gildata_Backtest.configurefiletype);','Gildata_Backtest_Input;']);
file3 = uimenu(file,'Label','批量导入策略','callback',['Configure_Gildata_Backtest.StrategyExample = file_importmultistrategy_callback(Configure_Gildata_Backtest.StrategyExample,Configure_Gildata_Backtest.Path_Strategy_Configure,Configure_Gildata_Backtest.Path_Search_Strategy, Configure_Gildata_Backtest.configurefiletype);','Gildata_Backtest_Input;']);
file4 = uimenu(file,'Label','保存图像','callback','file_save_callback(gcf);');
file5 = uimenu(file,'Label','退出','callback','file_closefigure_callback;');

%  table tool
tool = uimenu('Label','工具');
tool1 = 0;
% tool1 = uimenu(tool,'Label','展示工具','callback','handle_quicktool_Main = quicktool(gcf);');
% set(tool1, 'Enable','off');
tool2 = uimenu(tool,'Label','日历','callback','tool_calendar_callback();' );
tool3 = uimenu(tool,'Label','计算器','callback','tool_calc_callback();');
tool4  = uimenu(tool,'Label','数据下载工具','callback',' tool_download_callback(Configure_Gildata_Backtest.Path_Backtest_Cache);');

% table option
option = uimenu('Label','选项');
option1 = uimenu(option,'Label','基准设置' ,'callback','[Configure_Gildata_Backtest.benchmark,Configure_Gildata_Backtest.marketbench,Configure_Gildata_Backtest.riskfreebench,Configure_Gildata_Backtest.vara,Configure_Gildata_Backtest.varmethod] = option_setbenchmark(Configure_Gildata_Backtest.benchmark,Configure_Gildata_Backtest.marketbench,Configure_Gildata_Backtest.riskfreebench,Configure_Gildata_Backtest.vara,Configure_Gildata_Backtest.varmethod,Configure_Gildata_Backtest.path_backtest_configure, Configure_Gildata_Backtest.configurefiletype);');
option2 = uimenu(option,'Label','图像显示位置','callback','Configure_Gildata_Backtest.Figure_Position = option_setfigureposition(Configure_Gildata_Backtest.Figure_Position,Configure_Gildata_Backtest.path_backtest_configure,Configure_Gildata_Backtest.configurefiletype);');
% option3 = uimenu(option,'Label','设置策略样例路径','callback','option_setconfigurepath_callback(Configure_Gildata_Backtest.path_backtest_configure,Configure_Gildata_Backtest.configurefiletype);');
% 返回的菜单句柄 用于设置菜单选项可用或者不可用
handle =[file1,file2,file3,file4,file5,tool1,tool2,tool3,tool4,option1,option2];
end