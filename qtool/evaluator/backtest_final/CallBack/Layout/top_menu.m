%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������������ɲ˵���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handle = top_menu()

%��table file
file = uimenu('Label','�ļ�');
file1 = uimenu(file,'Label','���������������','callback','file_examplestrategy_callback();');
file2 = uimenu(file,'Label','�����������','callback',['Configure_Gildata_Backtest.StrategyExample = file_importsinglestrategy_callback(Configure_Gildata_Backtest.StrategyExample,Configure_Gildata_Backtest.Path_Strategy_Configure,Configure_Gildata_Backtest.configurefiletype);','Gildata_Backtest_Input;']);
file3 = uimenu(file,'Label','�����������','callback',['Configure_Gildata_Backtest.StrategyExample = file_importmultistrategy_callback(Configure_Gildata_Backtest.StrategyExample,Configure_Gildata_Backtest.Path_Strategy_Configure,Configure_Gildata_Backtest.Path_Search_Strategy, Configure_Gildata_Backtest.configurefiletype);','Gildata_Backtest_Input;']);
file4 = uimenu(file,'Label','����ͼ��','callback','file_save_callback(gcf);');
file5 = uimenu(file,'Label','�˳�','callback','file_closefigure_callback;');

%  table tool
tool = uimenu('Label','����');
tool1 = 0;
% tool1 = uimenu(tool,'Label','չʾ����','callback','handle_quicktool_Main = quicktool(gcf);');
% set(tool1, 'Enable','off');
tool2 = uimenu(tool,'Label','����','callback','tool_calendar_callback();' );
tool3 = uimenu(tool,'Label','������','callback','tool_calc_callback();');
tool4  = uimenu(tool,'Label','�������ع���','callback',' tool_download_callback(Configure_Gildata_Backtest.Path_Backtest_Cache);');

% table option
option = uimenu('Label','ѡ��');
option1 = uimenu(option,'Label','��׼����' ,'callback','[Configure_Gildata_Backtest.benchmark,Configure_Gildata_Backtest.marketbench,Configure_Gildata_Backtest.riskfreebench,Configure_Gildata_Backtest.vara,Configure_Gildata_Backtest.varmethod] = option_setbenchmark(Configure_Gildata_Backtest.benchmark,Configure_Gildata_Backtest.marketbench,Configure_Gildata_Backtest.riskfreebench,Configure_Gildata_Backtest.vara,Configure_Gildata_Backtest.varmethod,Configure_Gildata_Backtest.path_backtest_configure, Configure_Gildata_Backtest.configurefiletype);');
option2 = uimenu(option,'Label','ͼ����ʾλ��','callback','Configure_Gildata_Backtest.Figure_Position = option_setfigureposition(Configure_Gildata_Backtest.Figure_Position,Configure_Gildata_Backtest.path_backtest_configure,Configure_Gildata_Backtest.configurefiletype);');
% option3 = uimenu(option,'Label','���ò�������·��','callback','option_setconfigurepath_callback(Configure_Gildata_Backtest.path_backtest_configure,Configure_Gildata_Backtest.configurefiletype);');
% ���صĲ˵���� �������ò˵�ѡ����û��߲�����
handle =[file1,file2,file3,file4,file5,tool1,tool2,tool3,tool4,option1,option2];
end