%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本脚本用于展现策略累计收益率以及区间收益率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　清除多余变量和图形界面
clf reset;
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

% 重新设置figure的设定
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% 菜单栏
menu_handle = top_menu();

% 5个选项卡
top_tab();

% 累计收益率图
handle_Equity = draw_main_e(gcf,Displaydata.Equity);

% 累计收益率与区间收益率切换的radio
[radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity] = radio_topright(gcf);
set(radio5_Equity,'value',get(radio5_Equity,'Max'));

% 右图1
draw_right1_e(gcf,Displaydata.Equity);
% 右图2
draw_right2_e(gcf,Displaydata.Equity);
% 右图3
draw_right3_e(gcf,Displaydata.Equity);


