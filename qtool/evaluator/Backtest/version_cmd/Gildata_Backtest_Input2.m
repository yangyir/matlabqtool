%　清除多余变量和图形界面
clf ;
file_input = uimenu('Label','文件');
uimenu(file_input,'Label','退出','callback','file_closefigure_callback;');

set (gcf,'numbertitle','off','name','回测报告GUI');
% 重新设置figure的设定
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

%  布局页面
uicontrol('style','frame','position',[0.03,0.2,0.8,0.69]);

% 选项卡
push1_Input = uicontrol(gcf,'style','togglebutton','string','输入参数','fontsize',12,'position',[0.03,0.9,0.1,0.05]);

% 策略下拉菜单
[popupmenu_Input,nargin_num] = choosestrategypopupmenu2(Configure_Gildata_Backtest);

% 日期下拉菜单
uicontrol(gcf,'style','text','position',[0.10,0.70,0.0189,0.03],'string','1','fontsize',12);
dateEditBoxHandle1_Input = uicontrol(gcf, 'Style', 'Edit', 'Position', [0.12,0.70,0.12,0.04], 'BackgroundColor', 'w','fontsize',11);
calendarButtonHandle1_Input = uicontrol(gcf, 'Style', 'PushButton', 'String', '起始日期','Position', [0.26,0.71,0.08,0.03],'fontsize',12);
set(calendarButtonHandle1_Input,'callback', 'calendar_callback(dateEditBoxHandle1_Input);');
uicontrol(gcf,'style','text','position',[0.43,0.70,0.0189,0.03],'string','2','fontsize',12);
dateEditBoxHandle2_Input = uicontrol(gcf, 'Style', 'Edit', 'Position', [0.45,0.70,0.12,0.04], 'BackgroundColor', 'w','fontsize',11);
calendarButtonHandle2_Input = uicontrol(gcf, 'Style', 'PushButton', 'String', '截止日期','Position', [0.59,0.71,0.08,0.03],'fontsize',12);
set(calendarButtonHandle2_Input, 'callback', 'calendar_callback(dateEditBoxHandle2_Input);;');



% 参数输入栏
Pos1 = [0.12,0.64,0.12,0.04];
Pos2 = [0.26,0.65,0.07,0.03];
Pos3 = [0.33,0.65,0.07,0.03];
[edit1_Input,r1_Input,r2_Input,edit11_Input,pushbutton1_Input] = Combination1edit2radio2(gcf,Pos1,Pos2,Pos3,'3');
set(r1_Input,'callback','set_radio_state([r1_Input,r2_Input]);' );
set(r2_Input,'callback','set_radio_state([r2_Input,r1_Input]);' );
set(pushbutton1_Input,'callback','getargument(edit11_Input,edit1_Input);');

Pos1 = [0.45,0.64,0.12,0.04];
Pos2 = [0.59,0.65,0.07,0.03];
Pos3 = [0.66,0.65,0.07,0.03];
[edit2_Input,r3_Input,r4_Input,edit12_Input,pushbutton2_Input] = Combination1edit2radio2(gcf,Pos1,Pos2,Pos3,'4');
set(r3_Input,'callback','set_radio_state([r3_Input,r4_Input]);' );
set(r4_Input,'callback','set_radio_state([r4_Input,r3_Input]);' );
set(pushbutton2_Input,'callback','getargument(edit12_Input,edit2_Input);');

Pos1 = [0.12,0.53,0.12,0.04];
Pos2 = [0.26,0.54,0.07,0.03];
Pos3 = [0.33,0.54,0.07,0.03];
[edit3_Input,r5_Input,r6_Input,edit13_Input,pushbutton3_Input] = Combination1edit2radio2(gcf,Pos1,Pos2,Pos3,'5');
set(r5_Input,'callback','set_radio_state([r5_Input,r6_Input]);' );
set(r6_Input,'callback','set_radio_state([r6_Input,r5_Input]);' );
set(pushbutton3_Input,'callback','getargument(edit13_Input,edit3_Input);');

Pos1 = [0.45,0.53,0.12,0.04];
Pos2 = [0.59,0.54,0.07,0.03];
Pos3 = [0.66,0.54,0.07,0.03];
[edit4_Input,r7_Input,r8_Input,edit14_Input,pushbutton4_Input] = Combination1edit2radio2(gcf,Pos1,Pos2,Pos3,'6');
set(r7_Input,'callback','set_radio_state([r7_Input,r8_Input]);' );
set(r8_Input,'callback','set_radio_state([r8_Input,r7_Input]);' );
set(pushbutton4_Input,'callback','getargument(edit14_Input,edit4_Input);');

Pos1 = [0.12,0.43,0.12,0.04];
Pos2 = [0.26,0.44,0.07,0.03];
Pos3 = [0.33,0.44,0.07,0.03];
[edit5_Input,r9_Input,r10_Input,edit15_Input,pushbutton5_Input] = Combination1edit2radio2(gcf,Pos1,Pos2,Pos3,'7');
set(r9_Input,'callback','set_radio_state([r9_Input,r10_Input]);' );
set(r10_Input,'callback','set_radio_state([r10_Input,r9_Input]);' );
set(pushbutton5_Input,'callback','getargument(edit15_Input,edit5_Input);');

Pos1 = [0.45,0.43,0.12,0.04];
Pos2 = [0.59,0.44,0.07,0.03];
Pos3 = [0.66,0.44,0.07,0.03];
[edit6_Input,r11_Input,r12_Input,edit16_Input,pushbutton6_Input] = Combination1edit2radio2(gcf,Pos1,Pos2,Pos3,'8');
set(r11_Input,'callback','set_radio_state([r11_Input,r12_Input]);' );
set(r12_Input,'callback','set_radio_state([r12_Input,r11_Input]);' );
set(pushbutton6_Input,'callback','getargument(edit16_Input,edit6_Input);');

clearvars Pos1 Pos2 Pos3;

% 策略运行按钮

push6_Input = uicontrol(gcf,'style','pushbutton','position',[0.30,0.26,0.12,0.04],'string','执行','fontsize',12);
set(push6_Input,'callback',['[Configure_Gildata_Backtest.outfile,Configure_Gildata_Backtest.StrategyExample] = runstrategy_callback2(popupmenu_Input,handle,Configure_Gildata_Backtest);',...
    'Gildata_Backtest_Input2;']) ;

edit7_Input = uicontrol(gcf,'style','edit','position',[0.45,0.26,0.25,0.04],'fontsize',12,'BackgroundColor', 'w');
set(edit7_Input,'string',Configure_Gildata_Backtest.outfile);

uicontrol(gcf,'style','text','position',[0.71,0.26,0.10,0.04],'string','输出报表路径','fontsize',12);

handle =[dateEditBoxHandle1_Input,dateEditBoxHandle2_Input,edit1_Input,r1_Input,r2_Input,edit2_Input,...
    r3_Input,r4_Input,edit3_Input,r5_Input,r6_Input,edit4_Input,r7_Input,r8_Input,edit5_Input,r9_Input,...
    r10_Input,edit6_Input,r11_Input,r12_Input,edit7_Input,edit11_Input,pushbutton1_Input,edit12_Input,...
    pushbutton3_Input,edit13_Input,pushbutton3_Input,edit14_Input,pushbutton4_Input,edit15_Input,pushbutton5_Input...
    edit16_Input,pushbutton6_Input];


% 设置各参数控件初始状态
set_display2(Configure_Gildata_Backtest.StrategyExample(1,:),handle);
%  set(gcf,'position',[0.1,0.2,0.8,0.7])
