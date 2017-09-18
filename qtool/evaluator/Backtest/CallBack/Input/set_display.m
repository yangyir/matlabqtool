%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数根据相应策略所要输入参数个数，将数据样例中参数输出到相应控件中，多余的
% 控件设为不可用。
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


