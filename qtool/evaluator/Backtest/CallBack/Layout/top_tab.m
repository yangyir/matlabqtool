%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������������ͼ�ν�����5��ѡ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [push1_Input,push2_Input,push3_Input,push4_Input,push5_Input] = top_tab()

push1_Input = uicontrol(gcf,'style','togglebutton','string','�������','fontsize',12,'position',[0.03,0.9,0.1,0.05]);
set(push1_Input,'callback','Gildata_Backtest_Input');
push2_Input = uicontrol(gcf,'style','togglebutton','string','�۸�ͼ','fontsize',12,'position',[0.14,0.9,0.1,0.05]);
set(push2_Input,'callback','Gildata_Backtest_Main');
push3_Input = uicontrol(gcf,'style','togglebutton','string','Ȩ��ͼ','fontsize',12,'position',[0.25,0.9,0.1,0.05]);
set(push3_Input,'callback','Gildata_Backtest_Equity');
push4_Input = uicontrol(gcf,'style','togglebutton','string','�����嵥','fontsize',12,'position',[0.36,0.9,0.1,0.05]);
set(push4_Input,'callback','Gildata_Backtest_BuySellPoint');
push5_Input = uicontrol(gcf,'style','togglebutton','string','ͳ��ָ��','fontsize',12,'position',[0.47,0.9,0.1,0.05]);
set(push5_Input,'callback','Gildata_Backtest_StatisticalIndex');

end