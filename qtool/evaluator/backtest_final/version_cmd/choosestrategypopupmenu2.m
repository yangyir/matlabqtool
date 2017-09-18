%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数为策略选择控件的初始设置以及callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [popupmenu_Input,nargin_num] = choosestrategypopupmenu2(Configure_Gildata_Backtest)
% 策略下拉菜单popupmenu_Input的字符串
strategy_name_string = readstrategyname(Configure_Gildata_Backtest.StrategyExample(:,1));
% 策略下拉菜单popupmenu_Input

% uicontrol(gcf,'style','text','position',[0.12,0.76,0.24,0.03],'string',...
%     '策略输出接口参考calc_data_display.m','fontsize',12);
popupmenu_Input = uicontrol(gcf,'style','popupmenu','position',[0.27,0.78,0.17,0.04],'string',...
    strategy_name_string,'fontsize',12,'BackgroundColor','y');
uicontrol(gcf,'style','text','position',[0.4511,0.78,0.08,0.03],'string',...
    '选择策略','fontsize',12);
% 策略下拉菜单popupmenu_Input的初始设置
strategy_value = get(popupmenu_Input,'value');
strategyname = Configure_Gildata_Backtest.StrategyExample{strategy_value,1};
nargin_num = nargin(strategyname);
% 策略下拉菜单popupmenu_Input的callback
set(popupmenu_Input,'callback',['clear Displaydata;','changestrategy2(popupmenu_Input,Configure_Gildata_Backtest.StrategyExample,handle);']);

end