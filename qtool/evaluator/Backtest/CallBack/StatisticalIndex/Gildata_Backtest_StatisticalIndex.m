%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ű�����չ�ֲ���ͳ��ָ��
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

% �鿴ͳ��ָ�껹�Ƿ���ָ��
radio1_StatisticalIndex = uicontrol(gcf,'style','radio','position',[0.69,0.86,0.07,0.03]...
    ,'string','ͳ��ָ��','fontsize',10,'callback','set_radio_state([radio1_StatisticalIndex,radio2_StatisticalIndex]);');
set(radio1_StatisticalIndex,'value',get(radio1_StatisticalIndex,'Max'));
radio2_StatisticalIndex = uicontrol(gcf,'style','radio','position',[0.76,0.86,0.07,0.03]...
    ,'string','����ָ��','fontsize',10,'callback',['set_radio_state([radio2_StatisticalIndex,radio1_StatisticalIndex]);','Gildata_Backtest_RiskIndex;']);

if ~isfield(Displaydata,'RiskIndex')
    set(radio2_StatisticalIndex,'Enable','off');
end

text11_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.80,0.08,0.03],'string',...
    '��������','fontsize',12);
text12_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.7,0.08,0.03],'string',...
    '��ʼ�ʲ���ֵ','fontsize',12);
text13_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.6,0.08,0.03],'string',...
    '������','fontsize',12);
text14_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.5,0.08,0.03],'string',...
    '�����ʲ���ֵ','fontsize',12);
text15_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.4,0.08,0.03],'string',...
    '��׼�����','fontsize',12);
text16_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.3,0.08,0.03],'string',...
    '��׼���','fontsize',12);
text17_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.2,0.08,0.03],'string',...
    '�ۼ������� ','fontsize',12);
text18_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.08,0.1,0.08,0.03],'string',...
    '������','fontsize',12);

text21_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.80,0.08,0.03],'string',...
    '��ƽ������','fontsize',12);
text22_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.7,0.08,0.03],'string',...
    '�����沨����','fontsize',12);
text23_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.6,0.08,0.03],'string',...
    '��ƽ������','fontsize',12);
text24_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.5,0.08,0.03],'string',...
    '�����沨����','fontsize',12);
text25_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.4,0.08,0.03],'string',...
    '��ƽ������','fontsize',12);
text26_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.3,0.08,0.03],'string',...
    '�����沨����','fontsize',12);
text27_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.2,0.08,0.03],'string',...
    '��ƽ������','fontsize',12);
text28_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.36,0.1,0.08,0.03],'string',...
    '�����沨����','fontsize',12);


text31_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.80,0.08,0.03],'string',...
    '���س�ʱ��','fontsize',12);
text32_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.7,0.08,0.03],'string',...
    '���س�','fontsize',12);
text33_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.6,0.08,0.05],'string',...
    '���س���ʱ��','fontsize',12);
text34_StatisticalIndex = uicontrol(gcf,'style','text','position',[0.64,0.5,0.08,0.03],'string',...
    '���س���','fontsize',12);
popupmenu1_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.4,0.08,0.05],'string',...
    ' ','fontsize',12);
popupmenu2_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.3,0.08,0.03],'string',...
    ' ','fontsize',12);
popupmenu3_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.2,0.08,0.03],'string',...
    ' ','fontsize',12);
popupmenu4_StatisticalIndex = uicontrol(gcf,'style','popupmenu','position',[0.64,0.1,0.08,0.03],'string',...
    ' ','fontsize',12);

test_day = strcat(num2str(Displaydata.StatisticalIndex.testday(1)),'(',num2str(Displaydata.StatisticalIndex.testday(2)),')');

edit11_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.8,0.10,0.03],'string',test_day); % ��������
edit12_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.7,0.10,0.03],'string', Displaydata.StatisticalIndex.initAsset); % ��ʼ�ʲ���ֵ
edit13_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.6,0.10,0.03],'string','0'); % ������
edit14_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.5,0.10,0.03],'string',Displaydata.StatisticalIndex.enddateAsset); % �����ʲ���ֵ
edit15_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.4,0.10,0.03],'string',Displaydata.StatisticalIndex.Coefficientofvariance); % ��׼�����
edit16_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.3,0.10,0.03],'string',Displaydata.StatisticalIndex.Standarddeviation); % ��׼���
edit17_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.2,0.10,0.03],'string',Displaydata.StatisticalIndex.TotalReturn); % �ۼ�������
edit18_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.18,0.1,0.10,0.03],'string',Displaydata.StatisticalIndex.std ); % ������

edit21_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.8,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_d_m); % ��ƽ������
edit22_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.7,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_d_s); % �����沨����
edit23_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.6,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_w_m); % ��ƽ������
edit24_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.5,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_w_s); % �����沨����
edit25_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.4,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_m_m); % ��ƽ������
edit26_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.3,0.10,0.03],'string', Displaydata.StatisticalIndex.interval_returns_m_s); % �����沨����
edit27_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.2,0.10,0.03],'string',Displaydata.StatisticalIndex.interval_returns_y_m); % ��ƽ������
edit28_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.46,0.1,0.10,0.03],'string',Displaydata.StatisticalIndex.interval_returns_y_s); % �����沨����


edit31_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.8,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdown_time); % ���س�ʱ��
edit32_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.7,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdown); % ���س�
edit33_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.6,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdownratio_time); % ���س���ʱ��
edit34_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.5,0.10,0.03],'string',Displaydata.StatisticalIndex.drawdownratio); % ���س���
edit35_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.4,0.10,0.03],'string','0'); % 
edit36_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.3,0.10,0.03],'string','0'); % 
edit37_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.2,0.10,0.03],'string','0'); % ???
edit38_StatisticalIndex = uicontrol(gcf,'style','edit','fontsize',12,'position',[0.74,0.1,0.10,0.03],'string','0'); % ???
% ������ɫ
handle_edit = [edit11_StatisticalIndex,edit12_StatisticalIndex,edit13_StatisticalIndex,edit14_StatisticalIndex,edit15_StatisticalIndex,edit16_StatisticalIndex,edit17_StatisticalIndex,edit18_StatisticalIndex,edit21_StatisticalIndex,edit22_StatisticalIndex,edit23_StatisticalIndex,edit24_StatisticalIndex,edit25_StatisticalIndex,edit26_StatisticalIndex,edit27_StatisticalIndex,edit28_StatisticalIndex,edit31_StatisticalIndex,edit32_StatisticalIndex,edit33_StatisticalIndex,edit34_StatisticalIndex,edit35_StatisticalIndex,edit36_StatisticalIndex,edit37_StatisticalIndex,edit38_StatisticalIndex];
handle_text = [text11_StatisticalIndex,text12_StatisticalIndex,text13_StatisticalIndex,text14_StatisticalIndex,text15_StatisticalIndex,text16_StatisticalIndex,text17_StatisticalIndex,text18_StatisticalIndex,text21_StatisticalIndex,text22_StatisticalIndex,text23_StatisticalIndex,text24_StatisticalIndex,text25_StatisticalIndex,text26_StatisticalIndex,text27_StatisticalIndex,text28_StatisticalIndex,text31_StatisticalIndex,text32_StatisticalIndex,text33_StatisticalIndex,text34_StatisticalIndex,popupmenu1_StatisticalIndex,popupmenu2_StatisticalIndex,popupmenu3_StatisticalIndex,popupmenu4_StatisticalIndex];
set(handle_edit,'BackgroundColor', 'w');
set(handle_text,'BackgroundColor', 'y');
