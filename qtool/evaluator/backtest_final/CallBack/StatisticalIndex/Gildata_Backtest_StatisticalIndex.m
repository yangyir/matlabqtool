%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本脚本用于展现策略统计指标
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

% 查看统计指标还是风险指标
radio1_StatisticalIndex = uicontrol(gcf,'style','radio','position',[0.69,0.86,0.07,0.03]...
    ,'string','统计指标','fontsize',10,'callback','set_radio_state([radio1_StatisticalIndex,radio2_StatisticalIndex]);');
set(radio1_StatisticalIndex,'value',get(radio1_StatisticalIndex,'Max'));
radio2_StatisticalIndex = uicontrol(gcf,'style','radio','position',[0.76,0.86,0.07,0.03]...
    ,'string','风险指标','fontsize',10,'callback',['set_radio_state([radio2_StatisticalIndex,radio1_StatisticalIndex]);','Gildata_Backtest_RiskIndex;']);

if ~isfield(Displaydata,'RiskIndex')
    set(radio2_StatisticalIndex,'Enable','off');
end

text11_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.80,0.08,0.03],'string',...
    '测试天数','fontsize',12);
text12_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.7,0.08,0.03],'string',...
    '初始资产总值','fontsize',12);
text13_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.6,0.08,0.03],'string',...
    '手续费','fontsize',12);
text14_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.5,0.08,0.03],'string',...
    '最终资产总值','fontsize',12);
text15_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.4,0.08,0.03],'string',...
    '标准离差率','fontsize',12);
text16_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.3,0.08,0.03],'string',...
    '标准离差','fontsize',12);
text17_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.2,0.08,0.03],'string',...
    '累计收益率 ','fontsize',12);
text18_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.1,0.08,0.03],'string',...
    '波动率','fontsize',12);

text21_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.80,0.08,0.03],'string',...
    '日平均收益','fontsize',12);
text22_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.7,0.08,0.03],'string',...
    '日收益波动率','fontsize',12);
text23_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.6,0.08,0.03],'string',...
    '周平均收益','fontsize',12);
text24_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.5,0.08,0.03],'string',...
    '周收益波动率','fontsize',12);
text25_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.4,0.08,0.03],'string',...
    '月平均收益','fontsize',12);
text26_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.3,0.08,0.03],'string',...
    '月收益波动率','fontsize',12);
text27_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.2,0.08,0.03],'string',...
    '年平均收益','fontsize',12);
text28_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.1,0.08,0.03],'string',...
    '年收益波动率','fontsize',12);


text31_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.80,0.08,0.03],'string',...
    '最大回撤时间','fontsize',12);
text32_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.7,0.08,0.03],'string',...
    '最大回撤','fontsize',12);
text33_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.6,0.08,0.05],'string',...
    '最大回撤比时间','fontsize',12);
text34_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.5,0.08,0.03],'string',...
    '最大回撤比','fontsize',12);
popupmenu1_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.4,0.08,0.05],'string',...
    ' ','fontsize',12);
popupmenu2_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.3,0.08,0.03],'string',...
    ' ','fontsize',12);
popupmenu3_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.2,0.08,0.03],'string',...
    ' ','fontsize',12);
popupmenu4_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.1,0.08,0.03],'string',...
    ' ','fontsize',12);

test_day = strcat(num2str(Displaydata.StatisticalIndex.testday(1)),'(',num2str(Displaydata.StatisticalIndex.testday(2)),')');

edit11_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.8,0.10,0.03],'string',test_day); % 测试天数
edit12_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.7,0.10,0.03],'string', Displaydata.StatisticalIndex.initAsset); % 初始资产总值
edit13_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.6,0.10,0.03],'string','0'); % 手续费
edit14_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.5,0.10,0.03],'string',Displaydata.StatisticalIndex.enddateAsset); % 最终资产总值
edit15_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.4,0.10,0.03],'string',Displaydata.StatisticalIndex.Coefficientofvariance); % 标准离差率
edit16_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.3,0.10,0.03],'string',Displaydata.StatisticalIndex.Standarddeviation); % 标准离差
edit17_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.2,0.10,0.03],'string',Displaydata.StatisticalIndex.TotalReturn); % 累计收益率
edit18_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.1,0.10,0.03],'string',Displaydata.StatisticalIndex.std ); % 波动率

edit21_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.8,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_d_m); % 日平均收益
edit22_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.7,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_d_s); % 日收益波动率
edit23_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.6,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_w_m); % 周平均收益
edit24_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.5,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_w_s); % 周收益波动率
edit25_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.4,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_m_m); % 月平均收益
edit26_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.3,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_m_s); % 月收益波动率
edit27_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.2,0.10,0.03],'string',Displaydata.StatisticalIndex.interval_returns_y_m); % 年平均收益
edit28_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.1,0.10,0.03],'string',Displaydata.StatisticalIndex.interval_returns_y_s); % 年收益波动率


edit31_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.8,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdown_time); % 最大回撤时间
edit32_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.7,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdown); % 最大回撤
edit33_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.6,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdownratio_time); % 最大回撤比时间
edit34_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.5,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdownratio); % 最大回撤比
edit35_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.4,0.10,0.03],'string','0'); % 
edit36_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.3,0.10,0.03],'string','0'); % 
edit37_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.2,0.10,0.03],'string','0'); % ???
edit38_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.1,0.10,0.03],'string','0'); % ???
% 设置颜色
handle_edit = [edit11_StatisticalIndex,edit12_StatisticalIndex,edit13_StatisticalIndex,edit14_StatisticalIndex,edit15_StatisticalIndex,edit16_StatisticalIndex,edit17_StatisticalIndex,edit18_StatisticalIndex,edit21_StatisticalIndex,edit22_StatisticalIndex,edit23_StatisticalIndex,edit24_StatisticalIndex,edit25_StatisticalIndex,edit26_StatisticalIndex,edit27_StatisticalIndex,edit28_StatisticalIndex,edit31_StatisticalIndex,edit32_StatisticalIndex,edit33_StatisticalIndex,edit34_StatisticalIndex,edit35_StatisticalIndex,edit36_StatisticalIndex,edit37_StatisticalIndex,edit38_StatisticalIndex];
handle_text = [text11_StatisticalIndex,text12_StatisticalIndex,text13_StatisticalIndex,text14_StatisticalIndex,text15_StatisticalIndex,text16_StatisticalIndex,text17_StatisticalIndex,text18_StatisticalIndex,text21_StatisticalIndex,text22_StatisticalIndex,text23_StatisticalIndex,text24_StatisticalIndex,text25_StatisticalIndex,text26_StatisticalIndex,text27_StatisticalIndex,text28_StatisticalIndex,text31_StatisticalIndex,text32_StatisticalIndex,text33_StatisticalIndex,text34_StatisticalIndex,popupmenu1_StatisticalIndex,popupmenu2_StatisticalIndex,popupmenu3_StatisticalIndex,popupmenu4_StatisticalIndex];
set(handle_edit,'BackgroundColor', 'w');
set(handle_text,'BackgroundColor', 'y');
