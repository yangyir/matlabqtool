%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ű�����չ�ֲ��������嵥
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������������ͼ�ν���
clf ('reset');
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

% ��������figure���趨
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% �˵���
menu_handle = top_menu();

% 5��ѡ�
top_tab();

% չʾ�����嵥
set_table_buysellpiont(gcf,Displaydata.Buysellpoint);