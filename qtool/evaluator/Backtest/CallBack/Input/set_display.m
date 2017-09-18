%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������������Ӧ������Ҫ������������������������в����������Ӧ�ؼ��У������
% �ؼ���Ϊ�����á�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_display(arg,handle)

arg_num = nargin(arg{1,1});
set(handle(1),'string',arg{1,2});
set(handle(2),'string',arg{1,4});

for Index = 1:(length(handle)-2)/3
    if Index <= arg_num-2
        set(handle(Index*3),'string',num2str(arg{1,2*Index+4}),'Enable','on');
        if arg{2*Index+5} == 1
            set(handle(Index*3+1),'value',get(handle(Index*3+1),'Min'),'Enable','on');
            set(handle(Index*3+2),'value',get(handle(Index*3+1),'Max'),'Enable','on');
        else
            set(handle(Index*3+1),'value',get(handle(Index*3+1),'Max'),'Enable','on');
            set(handle(Index*3+2),'value',get(handle(Index*3+1),'Min'),'Enable','on');
        end
    else
        set(handle(Index*3),'string',' ','Enable','off');
        set(handle(Index*3+1),'value',get(handle(Index*3+1),'Max'),'Enable','off');
        set(handle(Index*3+2),'value',get(handle(Index*3+2),'Min'),'Enable','off');
    end

end  
    
end


