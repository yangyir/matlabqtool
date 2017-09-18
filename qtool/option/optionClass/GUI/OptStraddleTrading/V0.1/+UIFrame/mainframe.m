function handles = mainframe
% 期权Straddle交易主界面
%handles = UIFrame.mainframe
% 吴云峰 230170318


% 主交易界面
srsz = get(0, 'ScreenSize');
backgroundcolor = [0.8, 1, 0.8];
hFig_srsz = [srsz(1) srsz(2) srsz(3)*0.9 srsz(4)*0.8];
handles.output = figure('Position', hFig_srsz, 'ToolBar', 'figure', 'Menubar', 'none', ...
    'Color', backgroundcolor);
set(handles.output, 'Name', '期权Straddle交易', 'NumberTitle', 'off')


% 账户的选择
parent = handles.output;
handles.text_account_select = uicontrol('Parent', parent, 'style', 'text', 'Backgroundcolor', backgroundcolor, ...
    'String', '账户选择', 'Units', 'Normalized', 'Position', [0.005 0.96 0.05 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold');
handles.popup_account_select = uicontrol('Parent', parent, 'style', 'popupmenu', 'Backgroundcolor', 'k', ...
    'Foregroundcolor', 'w', 'String', {'账户选择'}, 'Units', 'Normalized', ...
    'Position', [0.06 0.96 0.05 0.035], 'FontSize', 9, 'FontWeight', 'bold');
handles.text_account_name    = uicontrol('Parent', parent, 'style', 'text', 'Backgroundcolor', backgroundcolor, ...
    'String', '账户名称', 'Units', 'Normalized', 'Position', [0.115 0.96 0.05 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold');
handles.edit_account_name    = uicontrol('Parent', parent, 'style', 'edit', 'Backgroundcolor', 'w', ...
    'String', '2016 | 2601 | 2034', 'Units', 'Normalized', 'Position', [0.165 0.963 0.18 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold', 'Enable', 'Inactive');
handles.text_account_proportion  = uicontrol('Parent', parent, 'style', 'text', 'Backgroundcolor', backgroundcolor, ...
    'String', '账户比例(比例之间使用/符号作为间隔,按照账户名称顺序排列)', 'Units', 'Normalized', 'Position', [0.345 0.96 0.25 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold');
handles.edit_pre_account_proportion  = uicontrol('Parent', parent, 'style', 'edit', 'Backgroundcolor', 'w', ...
    'String', '1/1/1', 'Units', 'Normalized', 'Position', [0.595 0.963 0.08 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold', 'Enable', 'on');
% 账户比例的设置
handles.button_account_proportion = uicontrol('Parent', parent, 'style', 'pushbutton', 'Backgroundcolor', 'k', ...
    'String', '账户比率设置', 'Units', 'Normalized', 'Position', [0.68 0.963 0.08 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold', 'Foregroundcolor', 'r');
handles.edit_after_account_proportion = uicontrol('Parent', parent, 'style', 'edit', 'Backgroundcolor', 'k', ...
    'String', '1:1:1', 'Units', 'Normalized', 'Position', [0.765 0.963 0.08 0.035], ...
    'FontSize', 9, 'FontWeight', 'bold', 'Enable', 'Inactive', 'Foregroundcolor', 'w');


% 子界面:下单
handles.extras = uiextras.TabPanel( 'Parent' , parent , 'ForegroundColor' , 'k' , 'BackgroundColor' , [1, 0.8, 1] , ...
    'FontSize' , 9 , 'FontWeight' ,'bold', 'Units', 'Normalized', 'Position', [0.001 0.001 0.998 0.958] );
handles.panel_entrust = uipanel( 'Parent' , handles.extras , 'BackgroundColor' , [1,1,0.7] );
handles.panel_payoff  = uipanel( 'Parent' , handles.extras , 'BackgroundColor' , [1,1,0.7] );
handles.panel_risk    = uipanel( 'Parent' , handles.extras , 'BackgroundColor' , [1,1,0.7] );
handles.extras.TabNames = {'下单','损益','风险'};



% 分界面的调整
handles.extras.TabSize       = 78;
handles.extras.SelectedChild = 1;









end