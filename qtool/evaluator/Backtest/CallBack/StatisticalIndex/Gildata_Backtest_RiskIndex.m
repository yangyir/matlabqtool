%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本脚本用于展现策略风险指标
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


radio1_RiskIndex = uicontrol(gcf,'style','radio','position',[0.69,0.86,0.07,0.03]...
    ,'string','统计指标','fontsize',10,'callback',['set_radio_state([radio2_RiskIndex,radio1_RiskIndex]);','Gildata_Backtest_StatisticalIndex;']);

radio2_RiskIndex = uicontrol(gcf,'style','radio','position',[0.76,0.86,0.07,0.03]...
    ,'string','风险指标','fontsize',10,'callback','set_radio_state([radio2_RiskIndex,radio1_RiskIndex]);');
set(radio2_RiskIndex,'value',get(radio2_RiskIndex,'Max'));

text11_RiskIndex = uicontrol(gcf,'style','text','position',[0.08,0.80,0.08,0.03],'string',...
    '总收益率','fontsize',12);
text12_RiskIndex = uicontrol(gcf,'style','text','position',[0.08,0.68,0.08,0.03],'string',...
    '年化波动率','fontsize',12);
text13_RiskIndex = uicontrol(gcf,'style','text','position',[0.08,0.56,0.08,0.03],'string',...
    'Alpha','fontsize',12);
text14_RiskIndex = uicontrol(gcf,'style','text','position',[0.08,0.44,0.08,0.03],'string',...
    'Beta','fontsize',12);
text15_RiskIndex = uicontrol(gcf,'style','text','position',[0.08,0.32,0.08,0.03],'string',...
    'VaR','fontsize',12);
text16_RiskIndex = uicontrol(gcf,'style','text','position',[0.08,0.20,0.08,0.03],'string',...
    '信息比率','fontsize',12);

text21_RiskIndex = uicontrol(gcf,'style','text','position',[0.36,0.80,0.08,0.03],'string',...
    '年化跟踪误差','fontsize',12);
text22_RiskIndex = uicontrol(gcf,'style','text','position',[0.36,0.68,0.08,0.03],'string',...
    'SharpRatio','fontsize',12);
text23_RiskIndex = uicontrol(gcf,'style','text','position',[0.36,0.56,0.08,0.05],'string',...
    'Conditional SharpRatio','fontsize',12);
text24_RiskIndex = uicontrol(gcf,'style','text','position',[0.36,0.44,0.08,0.05],'string',...
    'Modified SharpRatio','fontsize',12);
text25_RiskIndex = uicontrol(gcf,'style','text','position',[0.36,0.32,0.08,0.03],'string',...
    'Treynor Ratio','fontsize',12);
text26_RiskIndex = uicontrol(gcf,'style','text','position',[0.36,0.20,0.08,0.05],'string',...
    'Excess Return on VaR','fontsize',12);

text31_RiskIndex = uicontrol(gcf,'style','text','position',[0.64,0.80,0.08,0.03],'string',...
    'Calmar Ratio','fontsize',12);
text32_RiskIndex = uicontrol(gcf,'style','text','position',[0.64,0.68,0.08,0.03],'string',...
    'Kappa3','fontsize',12);
text33_RiskIndex = uicontrol(gcf,'style','text','position',[0.64,0.56,0.08,0.03],'string',...
    'Sterling Ratio','fontsize',12);
text34_RiskIndex = uicontrol(gcf,'style','text','position',[0.64,0.44,0.08,0.03],'string',...
    'Burke Ratio','fontsize',12);
text35_RiskIndex = uicontrol(gcf,'style','text','position',[0.64,0.32,0.08,0.03],'string',...
    'Omega','fontsize',12);
text36_RiskIndex = uicontrol(gcf,'style','text','position',[0.64,0.20,0.08,0.03],'string',...
    'Sortino Ratio','fontsize',12);

edit11_RiskIndex=uicontrol(gcf,'style','edit','position',[0.18,0.80,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.TotalReturn);
edit12_RiskIndex=uicontrol(gcf,'style','edit','position',[0.18,0.68,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.annstd);
edit13_RiskIndex=uicontrol(gcf,'style','edit','position',[0.18,0.56,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.Alpha);
edit14_RiskIndex=uicontrol(gcf,'style','edit','position',[0.18,0.44,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.Beta);
edit15_RiskIndex=uicontrol(gcf,'style','edit','position',[0.18,0.32,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.VaR);
edit16_RiskIndex=uicontrol(gcf,'style','edit','position',[0.18,0.20,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.InformationRatio);

edit21_RiskIndex=uicontrol(gcf,'style','edit','position',[0.46,0.80,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.trackingerror);
edit22_RiskIndex=uicontrol(gcf,'style','edit','position',[0.46,0.68,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.sharperatio);
edit23_RiskIndex=uicontrol(gcf,'style','edit','position',[0.46,0.56,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.conditionalSharpeR);
edit24_RiskIndex=uicontrol(gcf,'style','edit','position',[0.46,0.44,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.modifiedSharpeR);
edit25_RiskIndex=uicontrol(gcf,'style','edit','position',[0.46,0.32,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.Treynor);
edit26_RiskIndex=uicontrol(gcf,'style','edit','position',[0.46,0.20,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.exRetVaR);

edit31_RiskIndex=uicontrol(gcf,'style','edit','position',[0.74,0.80,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.calmarR);
edit32_RiskIndex=uicontrol(gcf,'style','edit','position',[0.74,0.68,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.kappaC);
edit33_RiskIndex=uicontrol(gcf,'style','edit','position',[0.74,0.56,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.sterlingR);
edit34_RiskIndex=uicontrol(gcf,'style','edit','position',[0.74,0.44,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.burkeR);
edit35_RiskIndex=uicontrol(gcf,'style','edit','position',[0.74,0.32,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.omegaC);
edit36_RiskIndex=uicontrol(gcf,'style','edit','position',[0.74,0.20,0.10,0.03],'fontsize',12,'string',Displaydata.RiskIndex.SoRa);

% 设置颜色
handle_edit = [edit11_RiskIndex,edit12_RiskIndex,edit13_RiskIndex,edit14_RiskIndex,edit15_RiskIndex,edit16_RiskIndex,edit21_RiskIndex,edit22_RiskIndex,edit23_RiskIndex,edit24_RiskIndex,edit25_RiskIndex,edit26_RiskIndex,edit31_RiskIndex,edit32_RiskIndex,edit33_RiskIndex,edit34_RiskIndex,edit35_RiskIndex,edit36_RiskIndex,];
handle_text = [text11_RiskIndex,text12_RiskIndex,text13_RiskIndex,text14_RiskIndex,text15_RiskIndex,text16_RiskIndex,text21_RiskIndex,text22_RiskIndex,text23_RiskIndex,text24_RiskIndex,text25_RiskIndex,text26_RiskIndex,text31_RiskIndex,text32_RiskIndex,text33_RiskIndex,text34_RiskIndex,text35_RiskIndex,text36_RiskIndex];
set(handle_edit,'BackgroundColor', 'w');
set(handle_text,'BackgroundColor', 'y');
