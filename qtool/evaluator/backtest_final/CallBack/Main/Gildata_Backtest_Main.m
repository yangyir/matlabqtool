%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ű�����չ�ֲ��������漰֤ȯ����ʼ�յ���ֹ��֮��۸�����ͼ���Լ�����ʱ�㡣
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������������ͼ�ν���
clf reset;
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

% ��������figure���趨
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% �˵���
menu_handle = top_menu();
% ��չ�ֹ�����Ϊ����
% set(menu_handle(6), 'Enable','on');

% 5��ѡ�
top_tab();

% ����ļ۸�ͼ
main_m = draw_main_m(gcf,Displaydata.Main);

% ��ͼ1
right1_m = draw_right1_m(gcf,Displaydata.Main);
% ��ͼ2
right2_m = draw_right2_m(gcf,Displaydata.Main);
% ��ͼ3
right3_m = draw_right3_m(gcf,Displaydata.Main);

% ������ͼ��ɫ
% handle_child = get(main_m,'child');
% set(handle_child(3),'color',[0,0.5,1]);
