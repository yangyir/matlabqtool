%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本脚本用于展现策略中所涉及证券从起始日到截止日之间价格曲线图，以及买卖时点。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　清除多余变量和图形界面
clf reset;
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

% 重新设置figure的设定
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% 菜单栏
menu_handle = top_menu();
% 将展现工具设为可用
% set(menu_handle(6), 'Enable','on');

% 5个选项卡
top_tab();

% 主体的价格图
main_m = draw_main_m(gcf,Displaydata.Main);

% 右图1
right1_m = draw_right1_m(gcf,Displaydata.Main);
% 右图2
right2_m = draw_right2_m(gcf,Displaydata.Main);
% 右图3
right3_m = draw_right3_m(gcf,Displaydata.Main);

% 设置主图颜色
% handle_child = get(main_m,'child');
% set(handle_child(3),'color',[0,0.5,1]);
