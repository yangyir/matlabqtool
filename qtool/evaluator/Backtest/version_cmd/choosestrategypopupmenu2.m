%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ϊ����ѡ��ؼ��ĳ�ʼ�����Լ�callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [popupmenu_Input,nargin_num] = choosestrategypopupmenu2(Configure_Gildata_Backtest)
% ���������˵�popupmenu_Input���ַ���
strategy_name_string = readstrategyname(Configure_Gildata_Backtest.StrategyExample(:,1));
% ���������˵�popupmenu_Input

% uicontrol(gcf,'style','text','position',[0.12,0.76,0.24,0.03],'string',...
%     '��������ӿڲο�calc_data_display.m','fontsize',12);
popupmenu_Input = uicontrol(gcf,'style','popupmenu','position',[0.27,0.78,0.17,0.04],'string',...
    strategy_name_string,'fontsize',12,'BackgroundColor','y');
uicontrol(gcf,'style','text','position',[0.4511,0.78,0.08,0.03],'string',...
    'ѡ�����','fontsize',12);
% ���������˵�popupmenu_Input�ĳ�ʼ����
strategy_value = get(popupmenu_Input,'value');
strategyname = Configure_Gildata_Backtest.StrategyExample{strategy_value,1};
nargin_num = nargin(strategyname);
% ���������˵�popupmenu_Input��callback
set(popupmenu_Input,'callback',['clear Displaydata;','changestrategy2(popupmenu_Input,Configure_Gildata_Backtest.StrategyExample,handle);']);

end