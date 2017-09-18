%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 本函数用于将handle(1)对应的slider的value向下四舍五入后，
% 传递给handle(2)对应edit的string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_slider_num(handle)

Num=get(handle(1),'value'); 
set(handle(2),'string', num2str(floor(Num)));
end