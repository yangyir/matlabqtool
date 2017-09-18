%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本脚本用于展现策略买卖清单
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　清除多余变量和图形界面
clf ('reset');
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

% 重新设置figure的设定
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% 菜单栏
menu_handle = top_menu();

% 5个选项卡
top_tab();

% 展示买卖清单
set_table_buysellpiont(gcf,Displaydata.Buysellpoint);