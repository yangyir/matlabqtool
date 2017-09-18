%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于配置策略样例文件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function option_setconfigurepath_callback()

global path_backtest_configure ;
[FileName,FilePath] = uigetfile('Pick a file','on');

if ~(FileName == 0)
    folder_name = strcat(FilePath,FileName);
    Path_strategy = folder_name;
    xlswrite(path_backtest_configure ,Path_strategy,'configure','B3');
end

end