%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������������ͼ�ν���f��Ӧλ��Pos1,Pos2,Pos3�ֱ�����һ��edit��2��radio����
% ������Ӧ�ľ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [edit1_Input,r1_Input,r2_Input] = Combination1edit2radio(f,Pos1,Pos2,Pos3,s)

% �������
uicontrol(gcf,'style','text','position',[Pos1(1)-0.02,Pos1(2)+0.01,0.0189,0.03],'string',s,'fontsize',12);

edit1_Input = uicontrol(f,'style','edit','position',Pos1,...
'fontsize',12,'BackgroundColor', 'w');
r1_Input = uicontrol(f,'style','radio','position',Pos2...
    ,'string','��ֵ��','fontsize',12);
r2_Input = uicontrol(f,'style','radio','position',Pos3...
    ,'string','�ַ���','fontsize',12);


end