%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����������ۼ�������������������ת����һ��radio�ؼ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity] = radio_topright(f)

radio1_Equity = uicontrol(f,'style','radio','position',[0.651,0.86,0.04,0.03],'string','��','fontsize',10,...
    'callback','radio_Equity_callback(radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity,Displaydata.Equity,handle_Equity ,''d'')');

radio2_Equity = uicontrol(f,'style','radio','position',[0.692,0.86,0.04,0.03] ,'string','��','fontsize',10,...
   'callback','radio_Equity_callback(radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity,Displaydata.Equity,handle_Equity ,''w'')');

radio3_Equity = uicontrol(f,'style','radio','position',[0.733,0.86,0.04,0.03] ,'string','��','fontsize',10,...
   'callback','radio_Equity_callback(radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity,Displaydata.Equity,handle_Equity ,''m'')');
radio4_Equity = uicontrol(f,'style','radio','position',[0.774,0.86,0.04,0.03] ,'string','��','fontsize',10,...
   'callback','radio_Equity_callback(radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity,Displaydata.Equity,handle_Equity ,''y'')');

radio5_Equity = uicontrol(f,'style','radio','position',[0.60,0.86,0.05,0.03] ,'string','�ۼ�','fontsize',10,...
   'callback','radio_Equity_callback(radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity,Displaydata.Equity,handle_Equity ,''a'')');

end
