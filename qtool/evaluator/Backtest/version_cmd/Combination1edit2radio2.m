
function  [edit1_Input,r1_Input,r2_Input,edit11_Input,pushbutton_Input] = Combination1edit2radio2(f,Pos1,Pos2,Pos3,s)

% 参数标号
uicontrol(gcf,'style','text','position',[Pos1(1)-0.02,Pos1(2)+0.01,0.0189,0.03],'string',s,'fontsize',12);

edit1_Input = uicontrol(f,'style','edit','position',Pos1,...
'fontsize',12,'BackgroundColor', 'w');
r1_Input = uicontrol(f,'style','radio','position',Pos2...
    ,'string','数值型','fontsize',12);
r2_Input = uicontrol(f,'style','radio','position',Pos3...
    ,'string','字符型','fontsize',12);

edit11_Input = uicontrol(gcf,'style','edit','position',[Pos1(1),Pos1(2)-0.05,0.20,0.04],...
'fontsize',12,'BackgroundColor', 'w');
pushbutton_Input = uicontrol(gcf,'style','pushbutton','position',[Pos3(1),Pos3(2)-0.05,0.07,0.03]...
    ,'string','读取文件','fontsize',12);
end