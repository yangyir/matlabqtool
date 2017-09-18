%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ű����ڲ��������ͼ�ν���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������������ͼ�ν���
clf ;
clearvars -except Gildata Displaydata Configure_Gildata_Backtest Path_usetowritedataintocache;

set (gcf,'numbertitle','off','name','�ز�GUI');
% ��������figure���趨
resetfigure(gcf,Configure_Gildata_Backtest.Figure_Position);

% ���ò˵�
menu_handle = top_menu();

%  ����ҳ��
uicontrol('style','frame','position',[0.03,0.2,0.8,0.69]);

% 5��ѡ�
[push1_Input,push2_Input,push3_Input,push4_Input,push5_Input] = top_tab();

% �������ݴ�����ɱ�־
h4_Input = finish_mark();


% ���������˵�
[popupmenu_Input,nargin_num] = choosestrategypopupmenu(Configure_Gildata_Backtest);

% ���������˵�
uicontrol(gcf,'style','text','position',[0.10,0.70,0.0189,0.03],'string','1','fontsize',12);
dateEditBoxHandle1_Input = uicontrol(gcf, 'Style', 'Edit', 'Position', [0.12,0.70,0.12,0.04], 'BackgroundColor', 'w','fontsize',11);
calendarButtonHandle1_Input = uicontrol(gcf, 'Style', 'PushButton', 'String', '��ʼ����','Position', [0.26,0.71,0.08,0.03],'fontsize',12);
set(calendarButtonHandle1_Input,'callback', 'calendar_callback(dateEditBoxHandle1_Input);');
uicontrol(gcf,'style','text','position',[0.43,0.70,0.0189,0.03],'string','2','fontsize',12);
dateEditBoxHandle2_Input = uicontrol(gcf, 'Style', 'Edit', 'Position', [0.45,0.70,0.12,0.04], 'BackgroundColor', 'w','fontsize',11);
calendarButtonHandle2_Input = uicontrol(gcf, 'Style', 'PushButton', 'String', '��ֹ����','Position', [0.59,0.71,0.08,0.03],'fontsize',12);
set(calendarButtonHandle2_Input, 'callback', 'calendar_callback(dateEditBoxHandle2_Input);;');



% ����������
Pos1 = [0.12,0.57,0.12,0.04];
Pos2 = [0.26,0.58,0.07,0.03];
Pos3 = [0.33,0.58,0.07,0.03];
[edit1_Input,r1_Input,r2_Input] = Combination1edit2radio(gcf,Pos1,Pos2,Pos3,'3');
set(r1_Input,'callback','set_radio_state([r1_Input,r2_Input]);' );
set(r2_Input,'callback','set_radio_state([r2_Input,r1_Input]);' );


Pos1 = [0.45,0.57,0.12,0.04];
Pos2 = [0.59,0.58,0.07,0.03];
Pos3 = [0.66,0.58,0.07,0.03];
[edit2_Input,r3_Input,r4_Input] = Combination1edit2radio(gcf,Pos1,Pos2,Pos3,'4');
set(r3_Input,'callback','set_radio_state([r3_Input,r4_Input]);' );
set(r4_Input,'callback','set_radio_state([r4_Input,r3_Input]);' );

Pos1 = [0.12,0.45,0.12,0.04];
Pos2 = [0.26,0.46,0.07,0.03];
Pos3 = [0.33,0.46,0.07,0.03];
[edit3_Input,r5_Input,r6_Input] = Combination1edit2radio(gcf,Pos1,Pos2,Pos3,'5');
set(r5_Input,'callback','set_radio_state([r5_Input,r6_Input]);' );
set(r6_Input,'callback','set_radio_state([r6_Input,r5_Input]);' );

Pos1 = [0.45,0.45,0.12,0.04];
Pos2 = [0.59,0.46,0.07,0.03];
Pos3 = [0.66,0.46,0.07,0.03];
[edit4_Input,r7_Input,r8_Input] = Combination1edit2radio(gcf,Pos1,Pos2,Pos3,'6');
set(r7_Input,'callback','set_radio_state([r7_Input,r8_Input]);' );
set(r8_Input,'callback','set_radio_state([r8_Input,r7_Input]);' );

Pos1 = [0.12,0.33,0.12,0.04];
Pos2 = [0.26,0.34,0.07,0.03];
Pos3 = [0.33,0.34,0.07,0.03];
[edit5_Input,r9_Input,r10_Input] = Combination1edit2radio(gcf,Pos1,Pos2,Pos3,'7');
set(r9_Input,'callback','set_radio_state([r9_Input,r10_Input]);' );
set(r10_Input,'callback','set_radio_state([r10_Input,r9_Input]);' );

Pos1 = [0.45,0.33,0.12,0.04];
Pos2 = [0.59,0.34,0.07,0.03];
Pos3 = [0.66,0.34,0.07,0.03];
[edit6_Input,r11_Input,r12_Input] = Combination1edit2radio(gcf,Pos1,Pos2,Pos3,'8');
set(r11_Input,'callback','set_radio_state([r11_Input,r12_Input]);' );
set(r12_Input,'callback','set_radio_state([r12_Input,r11_Input]);' );

clearvars Pos1 Pos2 Pos3;

% ����ָ��ѡ��
r13_Input = uicontrol(gcf,'style','radio','position',[0.46,0.27,0.04,0.03]...
    ,'string','��','fontsize',10,'callback','set_radio_state([r13_Input,r14_Input]);') ;
r14_Input= uicontrol(gcf,'style','radio','position',[0.51,0.27,0.04,0.03]...
    ,'string','��','fontsize',10,'callback','set_radio_state([r14_Input,r13_Input]);') ;
set(r14_Input,'value',get(r14_Input,'Max'));
uicontrol(gcf,'style','text','position',[0.46,0.24,0.08,0.03],'string',...
    '����ָ�����','fontsize',12);


% �������а�ť

push6_Input = uicontrol(gcf,'style','pushbutton','position',[0.30,0.26,0.12,0.04],'string','ִ��','fontsize',12); 
set(push6_Input,'callback',['[Displaydata,Configure_Gildata_Backtest.StrategyExample] = runstrategy_callback(h4_Input,popupmenu_Input,handle,r13_Input,handle_push,Configure_Gildata_Backtest);','Gildata_Backtest_Input;']) ;

handle =[dateEditBoxHandle1_Input,dateEditBoxHandle2_Input,edit1_Input,r1_Input,r2_Input,edit2_Input,r3_Input,r4_Input,edit3_Input,r5_Input,r6_Input,edit4_Input,r7_Input,r8_Input,edit5_Input,r9_Input,r10_Input,edit6_Input,r11_Input,r12_Input]; 
handle_push =[push1_Input,push2_Input,push3_Input,push4_Input,push5_Input,push6_Input];

% ���ø������ؼ���ʼ״̬
set_display(Configure_Gildata_Backtest.StrategyExample(1,:),handle);
if ~exist('Displaydata','var')
    set(handle_push(2:5),'Enable','off');
end


