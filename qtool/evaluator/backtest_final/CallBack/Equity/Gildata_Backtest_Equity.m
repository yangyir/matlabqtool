%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ű�����չ�ֲ����ۼ��������Լ�����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������������ͼ�ν���
clf reset;
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

% ��������figure���趨
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% �˵���
menu_handle = top_menu();

% 5��ѡ�
top_tab();

% �ۼ�������ͼ
handle_Equity = draw_main_e(gcf,Displaydata.Equity);

% �ۼ��������������������л���radio
[radio1_Equity,radio2_Equity,radio3_Equity,radio4_Equity,radio5_Equity] = radio_topright(gcf);
set(radio5_Equity,'value',get(radio5_Equity,'Max'));

% ��ͼ1
draw_right1_e(gcf,Displaydata.Equity);
% ��ͼ2
draw_right2_e(gcf,Displaydata.Equity);
% ��ͼ3
draw_right3_e(gcf,Displaydata.Equity);


